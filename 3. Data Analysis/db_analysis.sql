USE crm_sales;

# SALES TEAM PERFORMANCE
-- NOTE: Sales Teams are identified by the combination of regional_office and manager in the sales_teams table.

# 1) What is the sales volume and the number of won opportunities for each sales team?
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        COUNT(*) AS won_opportunities,
		SUM(sp.close_value) AS sales_revenue     
FROM sales_pipeline sp
JOIN sales_teams st	ON sp.agent_id = st.agent_id
WHERE sp.deal_stage = 'Won'
GROUP BY st.regional_office, st.manager
ORDER BY sales_revenue DESC;

# 2) Which sales teams have the highest success rate in closing deals? 
-- NOTE: The "Prospecting" and "Engaging" statuses represent intermediate phases in the sales process, so they are not included in the success rate calculation.
-- Success rate % = (Won deals/(Won + Lost deals)) * 100
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        ROUND((	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) /
				SUM(CASE WHEN sp.deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END))*100, 2) AS success_rate_pct
FROM sales_pipeline sp
JOIN sales_teams st ON sp.agent_id = st.agent_id
GROUP BY st.regional_office, st.manager
ORDER BY success_rate_pct DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# IDENTIFICATION OF UNDERPERFORMING SALES AGENTS 
# 1) Which sales agents have the lowest performance in terms of sales volume and won opportunities?
-- Check if there are any sales agents without assigned deals:
SELECT st.regional_office,
        st.manager,
        st.sales_agent
FROM sales_teams st 
WHERE NOT EXISTS (SELECT 1 FROM sales_pipeline sp WHERE sp.agent_id = st.agent_id);

-- Sales agents performance ranking:
SELECT st.sales_agent,
		SUM(sp.close_value) AS sales_revenue,
        DENSE_RANK () OVER (ORDER BY SUM(sp.close_value) DESC) AS revenue_rank,
        COUNT(*) AS won_opportunities,
        RANK () OVER (ORDER BY COUNT(*) DESC) AS won_opportunities_rank
FROM sales_pipeline sp
JOIN sales_teams st ON sp.agent_id = st.agent_id
WHERE sp.deal_stage = 'Won'
GROUP BY st.sales_agent
ORDER BY sales_revenue ASC, won_opportunities ASC;

-- Lowest performing sales agent of each team:
WITH ranked_sales_agents AS (
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        st.sales_agent,
        SUM(sp.close_value) AS sales_revenue,
        DENSE_RANK() OVER (PARTITION BY st.regional_office, st.manager ORDER BY SUM(sp.close_value) ASC) AS sales_rank_asc,
        COUNT(*) AS won_opportunities,
		DENSE_RANK() OVER (PARTITION BY st.regional_office, st.manager ORDER BY COUNT(*) ASC) AS opp_rank_asc
FROM sales_pipeline sp
JOIN sales_teams st ON sp.agent_id = st.agent_id
WHERE sp.deal_stage = 'Won'
GROUP BY st.regional_office, st.manager, st.sales_agent
)
SELECT teams_regional_office,
		teams_manager,
        sales_agent,
        sales_revenue,
        CASE WHEN sales_rank_asc = 1 THEN 'Yes' ELSE 'No' END AS 'lowest sales performance?',
        won_opportunities,
        CASE WHEN opp_rank_asc = 1 THEN 'Yes' ELSE 'No' END AS 'lowest opportunities performance?'
FROM ranked_sales_agents
WHERE sales_rank_asc = 1 OR opp_rank_asc = 1
ORDER BY teams_regional_office, teams_manager, sales_revenue;

# 2) What is the individual success rate of each sales agent, and how does it compare to the team success rate?
WITH sales_deals AS (
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        st.sales_agent,
        SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
        SUM(CASE WHEN sp.deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS won_lost_deals        
FROM sales_pipeline sp
JOIN sales_teams st ON sp.agent_id = st.agent_id
GROUP BY st.regional_office, st.manager, st.sales_agent
),
success_rates AS (
SELECT teams_regional_office,
		teams_manager,
        sales_agent,
        won_deals/won_lost_deals AS agents_success_rate,
        SUM(won_deals) OVER (sales_teams)/SUM(won_lost_deals) OVER (sales_teams) AS teams_success_rate
FROM sales_deals
WINDOW sales_teams AS (PARTITION BY teams_regional_office, teams_manager)
)
SELECT teams_regional_office,
		teams_manager,
        sales_agent,
        ROUND(agents_success_rate*100, 2) AS agents_success_rate_pct,
        ROUND(teams_success_rate*100, 2) AS team_success_rate_pct,
        CASE WHEN agents_success_rate > teams_success_rate THEN 'Above Team Average' ELSE 'Below Team Average' END AS success_rate_description
FROM success_rates
ORDER BY teams_regional_office, teams_manager, sales_agent;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# QUARTERLY TRENDS
-- Closing Dates information: 
SELECT MIN(close_date) AS first_close_date, 
		MAX(close_date) AS last_close_date
FROM sales_pipeline;

# 1) What are the quarter-over-quarter sales trends in terms of won opportunities and sales volume?
-- QoQ % change = ((Current quarter − Previous quarter)/Previous quarter) * 100 
WITH quarter_sales_opportunities AS (
SELECT QUARTER(close_date) AS quarter,
		COUNT(*) AS won_opportunities,
		SUM(close_value) AS sales_revenue
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY quarter
),
qoq_trends AS (
SELECT *,
		LAG(won_opportunities) OVER (ORDER BY quarter ASC) AS prev_won_opportunities,
        LAG(sales_revenue) OVER (ORDER BY quarter ASC) AS prev_sales_revenue
FROM quarter_sales_opportunities
)
SELECT quarter,
		won_opportunities,
		ROUND(((won_opportunities - prev_won_opportunities)/prev_won_opportunities)*100, 2) AS qoq_won_opportunities_growth_pct,
        sales_revenue,
        ROUND(((sales_revenue - prev_sales_revenue)/prev_sales_revenue)*100, 2) AS qoq_sales_revenue_growth_pct
FROM qoq_trends;

# 2) How do success rates for sales opportunities vary by quarter?
WITH quarter_sales_deals AS (
SELECT QUARTER(close_date) AS quarter,
		SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
        SUM(CASE WHEN deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS won_lost_deals
FROM sales_pipeline
WHERE close_date IS NOT NULL
GROUP BY quarter
),
qoq_success_rate AS (
SELECT *,
		won_deals/won_lost_deals AS success_rate,
        LAG(won_deals/won_lost_deals) OVER (ORDER BY quarter ASC) AS prev_success_rate
FROM quarter_sales_deals
)
SELECT quarter,
		ROUND(success_rate*100, 2) AS success_rate_pct,
		ROUND(((success_rate - prev_success_rate)/prev_success_rate)*100, 2) AS qoq_success_rate_growth_pct
FROM qoq_success_rate;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# PRODUCT SUCCESS RATE
# 1) Which products have the highest success rates in closing deals?
SELECT p.product_name,
		ROUND((	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) /
				SUM(CASE WHEN sp.deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END))*100, 2) AS success_rate_pct
FROM sales_pipeline sp
JOIN products p ON sp.product_id = p.product_id
GROUP BY p.product_name
ORDER BY success_rate_pct DESC;

# 2) Which products generate the most revenue, and how do they compare to other products?
WITH products_revenue AS (
SELECT p.product_name,
		SUM(sp.close_value) AS sales_revenue
FROM sales_pipeline sp
JOIN products p ON sp.product_id = p.product_id
WHERE sp.deal_stage = 'Won'
GROUP BY p.product_name
)
SELECT product_name,
		sales_revenue,
        ROUND((sales_revenue/SUM(sales_revenue) OVER ())*100, 2) AS revenue_pct
FROM products_revenue
ORDER BY sales_revenue DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# SECTOR PERFORMANCE
-- NOTE: A total of 1088 'Engaging' deals and 337 'Prospecting' deals are excluded from the sector performance analysis due to the lack of an assigned account.
-- Unassigned deals:
SELECT SUM(CASE WHEN deal_stage = 'Engaging' THEN 1 ELSE 0 END) AS unassigned_engaging_deals,
		SUM(CASE WHEN deal_stage = 'Prospecting' THEN 1 ELSE 0 END) AS unassigned_prospecting_deals
FROM sales_pipeline
WHERE account_id IS NULL;

# 1) Which sectors generate the most revenue and have the highest success rates?
SELECT a.sector,
		SUM(CASE WHEN sp.deal_stage = 'Won' THEN sp.close_value ELSE 0 END) AS sales_revenue,
		ROUND((	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) /
				SUM(CASE WHEN sp.deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END))*100, 2) AS success_rate_pct
FROM sales_pipeline sp
JOIN accounts a ON sp.account_id = a.account_id
GROUP BY a.sector
ORDER BY sales_revenue DESC, success_rate_pct DESC;


# 2) What is the distribution of opportunities by sector?
-- Win rate % = (Won deals / Total deals) * 100
-- Win-Loss ratio = Won deals / Lost deals
SELECT a.sector,
		SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won,
        SUM(CASE WHEN sp.deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost,
        SUM(CASE WHEN sp.deal_stage = 'Engaging' THEN 1 ELSE 0 END) AS engaging,
        SUM(CASE WHEN sp.deal_stage = 'Prospecting' THEN 1 ELSE 0 END) AS prospecting,
        COUNT(*) AS total,
		ROUND((SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END)/COUNT(*))*100, 2) AS win_rate_pct,
        ROUND(SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END)/SUM(CASE WHEN sp.deal_stage = 'Lost' THEN 1 ELSE 0 END), 2) AS win_loss_ratio
FROM sales_pipeline sp
JOIN accounts a ON sp.account_id = a.account_id
GROUP BY a.sector
ORDER BY won DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# SALES CYCLE DURATION 
-- NOTE: 'Engaging' or 'Prospecting' deals are excluded from sales cycle duration analysis due to the lack of a closing date.

# 1) What is the average sales cycle duration for won and lost opportunities?
SELECT deal_stage,
		ROUND(AVG(DATEDIFF(close_date, engage_date))) AS avg_sales_cycle_days,
        MAX(DATEDIFF(close_date, engage_date)) AS max_sales_cycle_days,
        MIN(DATEDIFF(close_date, engage_date)) AS min_sales_cycle_days
FROM sales_pipeline
WHERE deal_stage IN ('Won', 'Lost')
GROUP BY deal_stage;

# 2) How does the sales cycle duration vary by product or sector?
-- Sales cycle duration by product
SELECT p.product_name,
		ROUND(AVG(CASE WHEN sp.deal_stage = 'Won' THEN DATEDIFF(sp.close_date, sp.engage_date) END)) AS avg_won_sales_cycle_days,
		ROUND(AVG(CASE WHEN sp.deal_stage = 'Lost' THEN DATEDIFF(sp.close_date, sp.engage_date) END)) AS avg_lost_sales_cycle_days
FROM sales_pipeline sp
JOIN products p ON sp.product_id = p.product_id
GROUP BY p.product_name
ORDER BY avg_won_sales_cycle_days ASC, avg_lost_sales_cycle_days ASC;

-- Sales cycle duration by sector
SELECT a.sector,
		ROUND(AVG(CASE WHEN sp.deal_stage = 'Won' THEN DATEDIFF(sp.close_date, sp.engage_date) END)) AS avg_won_sales_cycle_days,
		ROUND(AVG(CASE WHEN sp.deal_stage = 'Lost' THEN DATEDIFF(sp.close_date, sp.engage_date) END)) AS avg_lost_sales_cycle_days
FROM sales_pipeline sp
JOIN accounts a ON sp.account_id = a.account_id
GROUP BY a.sector
ORDER BY avg_won_sales_cycle_days ASC, avg_lost_sales_cycle_days ASC;