# Data Preparation

## Data Examination

In the initial phase of the project, I examined the [**original data files**](https://github.com/natalyamn/CRM_Sales_Opportunities_project/tree/main/1.%20Data%20Preparation/original_files), which were provided in CSV format. Below is a summary of the fields contained in each CSV file: 

* `accounts.csv`: Contains information about the companies (accounts) involved in sales opportunities.
  * *account*: Company name
  * *sector*: Industry sector of the company
  * *year_established*: Year the company was established
  * *revenue*: Annual revenue of the company (in millions of USD)
  * *employees*: Number of employees
  * *office_location*: Headquarters location
  * *subsidiary_of*: Parent company, if applicable

* `sales_teams.csv`: Provides details about the sales agents and their management.
  * *sales_agent*: Name of the sales agent
  * *manager*: Name of the respective sales manager
  * *regional_office*: Location of the regional office

* `products.csv`: Contains data on the computer hardware products offered by the company.
  * *product*: Product name
  * *series*: Product series or family
  * *sales_price*: Suggested retail price

* `sales_pipeline.csv`: Records details of each sales opportunity within the pipeline.
  * *opportunity_id*: Unique identifier for each sales opportunity
  * *sales_agent*: Sales agent responsible for the opportunity
  * *product*: Product involved in the opportunity
  * *account*: Company involved in the opportunity, if applicable
  * *deal_stage*: Stage of the sales pipeline (e.g., Prospecting > Engaging > Won / Lost)
  * *engage_date*: Date when the "Engaging" stage of the deal was initiated, if applicable
  * *close_date*: Date when the deal was either "Won" or "Lost", if applicable
  * *close_value*: Revenue generated from the deal, if applicable

In the `sales_pipeline.csv` file, the columns *sales_agent*, *product*, and *account* originally contained full names that correspond to entries in the `sales_teams.csv`, `products.csv`, and `accounts.csv` files. 

To enhance efficiency, I added integer ID columns in the `sales_teams.csv`, `products.csv`, and `accounts.csv` files and replaced the full names in `sales_pipeline.csv` with these IDs. I made this modification to enhance the performance of database operations, particularly during joins, and to ensure consistency and accuracy across the dataset.

## Data Transformation

To prepare the data for efficient analysis, I took the following transformation steps:

1. **Add ID columns:** I added unique identifier (ID) columns to the `products.csv`, `accounts.csv`, and `sales_teams.csv` files. These IDs are now referenced in the `sales_pipeline.csv` file to standardize the data and make querying more efficient.

2. **Create mapping dictionaries:** I created dictionaries to map IDs to full names for the `products.csv`, `accounts.csv`, and `sales_teams.csv` files. These dictionaries serve as lookup tables, ensuring that each ID corresponds correctly to the appropriate name in the data.

3. **Validate data consistency:** I cross-referenced the dictionaries with the `sales_pipeline.csv` file to identify any discrepancies, such as names in `sales_pipeline.csv` that did not match those in the dictionaries. This validation step was crucial for maintaining data integrity.

4. **Correct misspelled values:** I corrected any misspelled values in the dictionaries to ensure consistency across all files. This helped prevent potential errors during data replacement that could have led to incorrect insights in future analyses.

5. **Replace full names with IDs:** I replaced the full names in the `sales_pipeline.csv` file with the corresponding IDs for sales agents, products, and accounts, standardizing the data for optimal querying.

6. **Save the updated data:** Finally, I saved the updated data in the `sales_pipeline.csv` file, ensuring it was properly prepared and optimized for the next phases of the project.


Additionally, I identified columns that contained empty string values:

* `accounts.csv`: *subsidiary_of*.

* `sales_pipeline.csv`: *account*, *engage_date*, *close_date* and *close_value*.

#### Data Transformation Tools and Outputs

I automated the data transformation process using a Python script, which is available in the following Jupyter Notebook:

* [**csv files preparation**](https://github.com/natalyamn/CRM_Sales_Opportunities_project/blob/main/1.%20Data%20Preparation/csv_files_preparation.ipynb)

The transformed data files resulting from this process can be found in the following directory:

* [**modified data files**](https://github.com/natalyamn/CRM_Sales_Opportunities_project/tree/main/1.%20Data%20Preparation/modified_files)
