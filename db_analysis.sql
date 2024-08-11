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
WITH lost_won_deals AS (
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
        SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals
FROM sales s
JOIN sales_teams st ON s.agent_id = st.agent_id
GROUP BY st.regional_office, st.manager
)
SELECT teams_regional_office,
		teams_manager,
        ROUND(((won_deals/(won_deals + lost_deals))*100), 2) AS success_rate_pct
FROM lost_won_deals
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
WITH lost_won_deals AS (
SELECT st.regional_office AS teams_regional_office,
		st.manager AS teams_manager,
        st.sales_agent,
        SUM(CASE WHEN s.deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
        SUM(CASE WHEN s.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals
FROM sales s
JOIN sales_teams st ON s.agent_id = st.agent_id
GROUP BY teams_regional_office, teams_manager, sales_agent
),
success_rates AS (
SELECT teams_regional_office,
		teams_manager,
        sales_agent,
        won_deals/(won_deals + lost_deals) AS agents_success_rate,
        SUM(won_deals) OVER (sales_teams)/(SUM(won_deals) OVER (sales_teams) + SUM(lost_deals) OVER (sales_teams)) AS teams_success_rate
FROM lost_won_deals
WINDOW sales_teams AS (PARTITION BY teams_regional_office, teams_manager)
)
SELECT teams_regional_office,
		teams_manager,
        sales_agent,
        ROUND(agents_success_rate*100,2) AS agents_success_rate_pct,
        ROUND(teams_success_rate*100,2) AS teams_success_rate_pct,
        CASE WHEN agents_success_rate > teams_success_rate THEN 'Above Team Average' ELSE 'Below Team Average' END AS success_rate_description
FROM success_rates
ORDER BY teams_regional_office, teams_manager, sales_agent;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# QUARTERLY TRENDS
# 1) What are the quarter-over-quarter sales trends in terms of won opportunities and sales volume?
# 2) How do success rates for sales opportunities vary by quarter?

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# PRODUCT SUCCESS RATE
# 1) Which products have the highest success rates in closing deals?
# 2) Which products generate the most revenue, and how do they compare to other products?

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# SECTOR PERFORMANCE
# 1) Which sectors generate the most revenue and have the highest success rates?
# 2) What is the distribution of won and lost opportunities by sector?

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# SALES CYCLE DURATION
# 1) What is the average sales cycle duration for won and lost opportunities?
# 2) How does the sales cycle duration vary by product or sector?