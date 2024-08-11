USE crm_sales;

# SALES TEAM PERFORMANCE
# 1) What is the sales volume and the number of won opportunities for each sales team?
-- NOTE: Sales Teams are identified by the combination of regional_office and manager in the sales_teams table.
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        COUNT(DISTINCT st.agent_id) AS number_of_salespersons,
        COUNT(*) AS won_opportunities,
		SUM(s.close_value) AS sales_revenue     
FROM sales s
JOIN sales_teams st	ON s.agent_id = st.agent_id
WHERE s.deal_stage = 'Won'
GROUP BY st.regional_office, st.manager
ORDER BY sales_revenue DESC;


# 2) Which sales teams have the highest success rate in closing deals? 
-- NOTE: The "Prospecting" and "Engaging" statuses represent intermediate phases in the sales process, so they are not included in the success rate calculation.
-- Success rate % = (Won deals/(Won + Lost deals)) * 100
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        ROUND((SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END)/SUM(CASE WHEN s.deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END))*100, 2) AS success_rate_pct
FROM sales s
JOIN sales_teams st ON s.agent_id = st.agent_id
GROUP BY st.regional_office, st.manager
ORDER BY success_rate_pct DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# IDENTIFICATION OF UNDERPERFORMING SALES AGENTS 
# 1) Which sales agents have the lowest performance in terms of sales volume and won opportunities?
-- Lowest performing sales agents in terms of sales volume:
WITH ranked_sales_revenue AS (
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        st.sales_agent,
        SUM(s.close_value) AS sales_revenue,
        DENSE_RANK() OVER (PARTITION BY st.regional_office, st.manager ORDER BY SUM(s.close_value) ASC) AS sales_rank
FROM sales s
JOIN sales_teams st ON s.agent_id = st.agent_id
WHERE s.deal_stage = 'Won'
GROUP BY teams_regional_office, teams_manager, sales_agent
)
SELECT teams_regional_office,
		teams_manager,
        sales_agent AS lowest_sales_revenue_agent,
        sales_revenue
FROM ranked_sales_revenue
WHERE sales_rank = 1;

-- Lowest performing sales agents in terms of won opportunities:
WITH ranked_won_opp AS (
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        st.sales_agent,
        COUNT(*) AS won_opp,
        DENSE_RANK() OVER (PARTITION BY st.regional_office, st.manager ORDER BY COUNT(*) ASC) AS opp_rank
FROM sales s
JOIN sales_teams st ON s.agent_id = st.agent_id
WHERE s.deal_stage = 'Won'
GROUP BY teams_regional_office, teams_manager, sales_agent
)
SELECT teams_regional_office,
		teams_manager,
        sales_agent AS lowest_won_opportunities_agent,
        won_opp AS won_opportunities
FROM ranked_won_opp
WHERE opp_rank = 1;


# 2) What is the individual success rate of each sales agent, and how does it compare to the team average?
WITH sales_deals AS (
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        st.sales_agent,
        SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals,
        SUM(CASE WHEN s.deal_stage IN ('Won', 'Lost') THEN 1 ELSE 0 END) AS total_deals        
FROM sales s
JOIN sales_teams st ON s.agent_id = st.agent_id
GROUP BY teams_regional_office, teams_manager, sales_agent
),
success_rates AS (
SELECT teams_regional_office,
		teams_manager,
        sales_agent,
        won_deals/total_deals AS agents_success_rate,
        SUM(won_deals) OVER (sales_teams)/SUM(total_deals) OVER (sales_teams) AS teams_success_rate
FROM sales_deals
WINDOW sales_teams AS (PARTITION BY teams_regional_office, teams_manager)
)
SELECT teams_regional_office,
		teams_manager,
        sales_agent,
        ROUND(agents_success_rate*100, 2) AS agents_success_rate_pct,
        ROUND(teams_success_rate*100, 2) AS teams_success_rate_pct,
        CASE WHEN agents_success_rate > teams_success_rate THEN 'Above Team Average' ELSE 'Below Team Average' END AS success_rate_description
FROM success_rates
ORDER BY teams_regional_office, teams_manager, sales_agent;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# QUARTERLY TRENDS
# 1) What are the quarter-over-quarter sales trends in terms of won opportunities and sales volume?
-- QoQ % change = ((Current quarter − Previous quarter)/Previous quarter) * 100 
WITH quarter_sales_opportunities AS (
SELECT QUARTER(close_date) AS quarter,
		COUNT(*) AS won_opportunities,
		SUM(close_value) AS sales_revenue
FROM sales
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
        SUM(CASE WHEN deal_stage IN ('Lost', 'Won') THEN 1 ELSE 0 END) AS total_deals
FROM sales
WHERE close_date IS NOT NULL
GROUP BY quarter
),
qoq_success_rate AS (
SELECT *,
		won_deals/total_deals AS success_rate,
        LAG(won_deals/total_deals) OVER (ORDER BY quarter ASC) AS prev_success_rate
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
		ROUND((SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END)/SUM(CASE WHEN s.deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END))*100, 2) AS success_rate_pct
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY success_rate_pct DESC;


# 2) Which products generate the most revenue, and how do they compare to other products?
WITH products_revenue AS (
SELECT p.product_name,
		SUM(s.close_value) AS sales_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE deal_stage = 'Won'
GROUP BY p.product_name
ORDER BY sales_revenue DESC
)
SELECT product_name,
		sales_revenue,
        ROUND((sales_revenue/SUM(sales_revenue) OVER ())*100, 2) AS revenue_pct
FROM products_revenue;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# SECTOR PERFORMANCE
# 1) Which sectors generate the most revenue and have the highest success rates?
SELECT c.sector,
		SUM(CASE WHEN s.deal_stage = 'Won' THEN s.close_value ELSE 0 END) AS sales_revenue,
		ROUND((SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END)/SUM(CASE WHEN s.deal_stage IN ('Won','Lost') THEN 1 ELSE 0 END))*100, 2) AS success_rate_pct
FROM sales s
JOIN companies c ON s.company_id = c.company_id
GROUP BY sector
ORDER BY sales_revenue DESC, success_rate_pct DESC;


# 2) What is the distribution of won and lost opportunities by sector?
WITH sector_opportunities AS (
SELECT c.sector,
		SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_opportunities,
        SUM(CASE WHEN s.deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_opportunities
FROM sales s
JOIN companies c ON s.company_id = c.company_id
GROUP BY c.sector
)
SELECT sector,
		won_opportunities,
        lost_opportunities,
        ROUND((won_opportunities/(won_opportunities + lost_opportunities))*100, 2) AS success_rate_pct
FROM sector_opportunities
ORDER BY won_opportunities DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# SALES CYCLE DURATION
# 1) What is the average sales cycle duration for won and lost opportunities?
# 2) How does the sales cycle duration vary by product or sector?