# Data Analysis

## Sales Team Performance

There are six distinct sales teams, each defined by the unique combination of regional office and manager in the **sales_teams** table.

### 1. What is the sales volume and the number of won opportunities for each sales team?

Here is a summary of the won opportunities and revenue for each sales team:

| Regional Office | Manager           | Won Opportunities | Revenue   |
|-----------------|-------------------|-------------------|-----------|
| Central         | Melvin Marxen     | 882               | 2,251,930 |
| West            | Summer Sewald     | 828               | 1,964,750 |
| East            | Rocco Neubert     | 691               | 1,960,545 |
| West            | Celia Rouche      | 610               | 1,603,897 |
| East            | Cara Losch        | 480               | 1,130,049 |
| Central         | Dustin Brinkmann  | 747               | 1,094,363 |

### 2. Which sales teams have the highest success rate in closing deals?

The sales team led by **Cara Losch** from the East regional office has the highest success rate at **64.43%**. Although this team did not have the highest number of won opportunities (480) or the highest revenue ($1,130,049), they outperformed other teams in terms of converting opportunities into successful deals.

In contrast, the team led by **Melvin Marxen** from the Central regional office has one of the lowest success rates at **62.20%**, despite having the highest number of won opportunities (882). This suggests that while they are closing more deals overall, the large volume of opportunities may be impacting their success rate, as they may be pursuing more challenging or less likely leads.

Here is the success rate of the remaining sales teams:

| Regional Office | Manager          | Success Rate (%)    |
|-----------------|------------------|--------------------|
| West            | Summer Sewald     | 64.34             |
| West            | Celia Rouche      | 63.41             |
| Central         | Dustin Brinkmann  | 62.98             |
| Central         | Melvin Marxen     | 62.20             |
| East            | Rocco Neubert     | 62.08             |


## Identification of Underperforming Sales Agents

### 1. Which sales agents have the lowest performance in terms of sales volume and won opportunities?

Some sales agents do not have any recorded opportunities. This could be due to various reasons, such as new hires who have not yet been assigned opportunities, or sales agents transitioning between roles. These agents should be reviewed to determine the cause:

| Regional Office | Manager         | Sales Agent          |
|-----------------|-----------------|----------------------|
| Central         | Melvin Marxen    | Mei-Mei Johns        |
| East            | Cara Losch       | Elizabeth Anderson   |
| East            | Rocco Neubert    | Natalya Ivanova      |
| West            | Celia Rouche     | Carol Thompson       |
| West            | Summer Sewald    | Carl Lin             |

Overall, the three agents with the worst revenue performance are:

| Sales Agent      | Revenue  | Revenue Rank |
|------------------|----------|--------------|
| Violet Mclelland | 123,431  | 30           |
| Wilburn Farren   | 157,640  | 29           |
| Niesha Huffines  | 176,961  | 28           |

And the agents with the worst performance in terms of won opportunities are:

| Sales Agent      | Won Opportunities | Won Opp Rank |
|------------------|-------------------|-------------|
| Wilburn Farren   | 55                | 30          |
| Rosalina Dieter  | 72                | 29          |
| Garret Kinder    | 75                | 28          |

Thus, the worst-performing agents in terms of revenue do not always match those with the lowest number of won opportunities.

I also analyzed the worst-performing agents within each team. Some agents perform poorly in both revenue and won opportunities, while others only rank poorly in one aspect:

| Regional Office | Manager         | Sales Agent      | Revenue  | Lowest Sales Performance? | Won Opp | Lowest Won Opp Performance? |
|-----------------|-----------------|------------------|----------|---------------------------|---------|----------------------------|
| Central         | Dustin Brinkmann | Versie Hillebrand | 187,693  | Yes                       | 176     | No                         |
| Central         | Dustin Brinkmann | Cecily Lampkin    | 229,800  | No                        | 107     | Yes                        |
| Central         | Melvin Marxen    | Niesha Huffines   | 176,961  | Yes                       | 105     | Yes                        |
| East            | Cara Losch       | Violet Mclelland  | 123,431  | Yes                       | 122     | No                         |
| East            | Cara Losch       | Wilburn Farren    | 157,640  | No                        | 55      | Yes                        |
| East            | Rocco Neubert    | Boris Faz         | 261,631  | Yes                       | 101     | Yes                        |
| West            | Celia Rouche     | Rosalina Dieter   | 235,403  | Yes                       | 72      | Yes                        |
| West            | Summer Sewald    | Kami Bicknell     | 316,456  | Yes                       | 174     | No                         |
| West            | Summer Sewald    | James Ascencio    | 413,533  | No                        | 135     | Yes                        |

### 2. What is the individual success rate of each sales agent, and how does it compare to the team average?

Here’s an overview of the success rate for each sales agent in **Dustin Brinkmann's** team compared to the team's overall success rate of **62.98%**:

| Regional Office | Manager         | Sales Agent      | Agent's Success Rate | Team's Success Rate | Description        |
|-----------------|-----------------|------------------|----------------------|---------------------|--------------------|
| Central         | Dustin Brinkmann | Anna Snelling    | 61.90                | 62.98               | Below Team Average |
| Central         | Dustin Brinkmann | Cecily Lampkin   | 66.88                | 62.98               | Above Team Average |
| Central         | Dustin Brinkmann | Lajuana Vencill  | 54.98                | 62.98               | Below Team Average |
| Central         | Dustin Brinkmann | Moses Frase      | 66.15                | 62.98               | Above Team Average |
| Central         | Dustin Brinkmann | Versie Hillebrand| 66.67                | 62.98               | Above Team Average |

Some agents, like **Versie Hillebrand** and **Cecily Lampkin**, are outperforming the team average in terms of success rate, despite not being the highest in revenue or won opportunities. This suggests that these agents are more efficient in closing deals. Meanwhile, **Anna Snelling** and **Lajuana Vencill** fall below the team's average, indicating room for improvement in their performance.


## Quarterly Trends

The first closing date for sales opportunities was on **2017-03-01**, and the last closing date was on **2017-12-31**.

### 1. What are the quarter-over-quarter sales trends in terms of won opportunities and sales volume?

| Quarter | Won Opp | QoQ Won Opp Growth (%) | Sales ($) | QoQ Sales Growth (%) |
|---------|---------|------------------------|-----------|----------------------|
| 1       | 531     |                        | 1,134,672 |                      |
| 2       | 1,254   | 136.16                 | 3,086,111 | 171.98               |
| 3       | 1,257   | 0.24                   | 2,982,255 | -3.37                |
| 4       | 1,196   | -4.85                  | 2,802,496 | -6.03                |

The first quarter has significantly lower sales volume and won opportunities. This might be because at the start of the year, the sales team was just getting started and their sales efforts were still getting up to speed, or because many deals that started early on may not have closed until later in the year.

### 2. How do success rates for sales opportunities vary by quarter?

| Quarter | Success Rate (%) | QoQ Variation (%) |
|---------|------------------|------------------|
| 1       | 82.07            |                  |
| 2       | 61.71            | -24.81           |
| 3       | 61.41            | -0.49            |
| 4       | 60.25            | -1.89            |

At the beginning of the year, the success rate was notably high, potentially due to a focus on closing high-probability opportunities early. However, as the year progressed, the success rate stabilized around 60%, possibly reflecting a broader range of deals, including more challenging or less certain opportunities.


## Product Success Rate

### 1. Which products have the highest success rates in closing deals?

Here are the success rates for each product:

| Product          | Success Rate (%) |
|------------------|------------------|
| MG Special       | 64.84            |
| GTX Plus Pro     | 64.30            |
| GTX Basic        | 63.72            |
| GTX Pro          | 63.56            |
| GTX Plus Basic   | 62.13            |
| MG Advanced      | 60.33            |
| GTK 500          | 60.00            |

Products with higher success rates might be those that better meet customers' needs or offer highly valued features. This could indicate that these products are well-aligned with customer preferences or have competitive advantages that make them easier to sell.

### 2. Which products generate the most revenue, and how do they compare to other products?

Here is a summary of the revenue generated by each product:

| Product          | Revenue ($) | Revenue Share (%) |
|------------------|-------------|-------------------|
| GTX Pro          | 3,510,578   | 35.09             |
| GTX Plus Pro     | 2,629,651   | 26.28             |
| MG Advanced      | 2,216,387   | 22.15             |
| GTX Plus Basic   | 705,275     | 7.05              |
| GTX Basic        | 499,263     | 4.99              |
| GTK 500          | 400,612     | 4.00              |
| MG Special       | 43,768      | 0.44              |

Products like **GTX Pro** and **GTX Plus Pro** generate the most revenue, which may be due to their higher sales volumes. In contrast, products with lower revenue, such as **MG Special**, might have been sold in fewer units.

The low revenue for some products could be related to their lower sales volumes or possibly higher prices, which may affect their attractiveness to customers. Additionally, the price factor is not analyzed here but could be a significant issue influencing both sales volume and success rates.


## Sector Performance

### 1. Which sectors generate the most revenue and have the highest success rates?

The top three sectors generating the most revenue are:

| Sector    | Revenue ($) | Success Rate (%) |
|-----------|-------------|------------------|
| Retail    | 1,867,528   | 63.06            |
| Technology| 1,515,487   | 63.42            |
| Medical   | 1,359,595   | 62.32            |

The sectors with the highest success rates are:

| Sector      | Revenue ($) | Success Rate (%) |
|-------------|-------------|------------------|
| Marketing   | 922,321     | 64.85            |
| Entertainment| 689,007    | 64.68            |
| Software    | 1,077,934   | 63.92            |

While the **Retail**, **Technology**, and **Medical** sectors generate the most revenue, they are not the top performers in success rates. **Marketing** and **Entertainment** sectors have the highest success rates, suggesting that these sectors might be more effective in closing deals. This indicates that even though some sectors generate higher revenue, others are more successful at converting opportunities into closed deals.

### 2. What is the distribution of opportunities by sector?

The following table shows an extract of the top 5 sectors with the most won opportunities:

| Sector      | Won | Lost | Engaging | Prospecting | Total | Win Rate (%) | Win/Loss Ratio |
|-------------|-----|------|----------|-------------|-------|--------------|----------------|
| Retail      | 799 | 468  | 94       | 36          | 1,397 | 57.19        | 1.71           |
| Technology  | 671 | 387  | 71       | 36          | 1,165 | 57.60        | 1.73           |
| Medical     | 592 | 358  | 77       | 24          | 1,051 | 56.33        | 1.65           |
| Software    | 450 | 254  | 43       | 10          | 757   | 59.45        | 1.77           |
| Marketing   | 404 | 219  | 40       | 11          | 674   | 59.94        | 1.84           |

The **Retail** sector has the highest number of won opportunities, followed by **Technology** and **Medical**. **Software** and **Marketing** sectors have higher win rates and win/loss ratios compared to others, indicating they are more successful in converting opportunities into closed deals. The higher win rates in **Software** and **Marketing** sectors might be due to their more effective sales strategies or a higher quality of leads.


## Sales Cycle Duration

### 1. What is the average sales cycle duration for won and lost opportunities?

| Deal Stage | Avg Sales Cycle Days | Max Sales Cycle Days | Min Sales Cycle Days |
|------------|-----------------------|----------------------|----------------------|
| Won        | 52                    | 138                  | 1                    |
| Lost       | 41                    | 138                  | 1                    |

Won Opportunities tend to have a longer average sales cycle (52 days) compared to Lost ones (41 days). This could be due to the additional time required to close more complex or high-value deals. Both won and lost opportunities have the same maximum sales cycle duration, indicating that some deals, regardless of outcome, can take a significant amount of time to close.

### 2. How does the sales cycle duration vary by product or sector?

**By Product:**

| Product         | Avg Won Sales Cycle Days | Avg Lost Sales Cycle Days |
|-----------------|---------------------------|---------------------------|
| GTX Pro         | 48                        | 41                        |
| MG Special      | 51                        | 43                        |
| GTX Plus Pro    | 52                        | 36                        |
| MG Advanced     | 52                        | 40                        |
| GTX Plus Basic  | 52                        | 46                        |
| GTX Basic       | 55                        | 41                        |
| GTK 500         | 64                        | 38                        |

The **GTK 500** product has the longest average sales cycle for won opportunities (64 days), which may suggest that it is a more complex or higher-value product, requiring more time to close deals.  

**By Sector** (Top 5 by Shortest Cycle for Won Opportunities):

| Sector         | Avg Won Sales Cycle Days | Avg Lost Sales Cycle Days |
|----------------|---------------------------|---------------------------|
| Marketing      | 49                        | 41                        |
| Entertainment  | 51                        | 47                        |
| Medical        | 52                        | 38                        |
| Technology     | 52                        | 39                        |
| Services       | 52                        | 39                        |

The **Marketing** sector has the shortest average sales cycle for won opportunities (49 days), suggesting that deals in this sector close relatively quickly. **Entertainment**, **Medical**, **Technology**, and **Services** sectors have similar sales cycle durations, with the cycle for lost opportunities being shorter in the **Medical** sector. This may indicate that some sectors have a more organized and effective approach to managing sales or fewer complications in closing deals.
