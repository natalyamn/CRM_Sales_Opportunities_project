# Data Preparation

## Data Examination

The initial phase of the project involves an examination of the [**original data files**](https://github.com/natalyamn/CRM_Sales_Opportunities_project/tree/main/1.%20Data%20Preparation/original_files), which are provided in CSV format. Below is a summary of the fields contained in each CSV file:

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

To enhance efficiency, I added integer ID columns in the `sales_teams.csv`, `products.csv`, and `accounts.csv` files and replaced the full names in `sales_pipeline.csv` with these IDs. I made this modification to enhance the performance of database operations, especially during joins, and to ensure consistency and accuracy across the dataset.

## Data Transformation

To prepare the data for efficient analysis, I took the following transformation steps:

1. Add ID column to the `products.csv`, `accounts.csv`, and `sales_teams.csv` files.
   * Each entry now has a unique identifier (ID) that corresponds to a specific product, account, or sales team.
   * This ID will be used as a reference in the `sales_pipeline.csv` file.

2. Create a dictionary to map IDs to full names for `products.csv`, `accounts.csv`, and `sales_teams.csv` files.
   * These dictionaries serve as reference tables, ensuring that each ID correctly corresponds to the appropriate name in the data.

3. Validate data consistency. 
   * The dictionaries were cross-referenced with the `sales_pipeline.csv` file to check for any discrepancies, such as names in `sales_pipeline.csv` that do not match those in the dictionaries.
   * This step is crucial for maintaining data integrity and ensuring that all relationships are correctly represented.

4. Correct misspelled values. 
   * Any misspelled values in the dictionaries were corrected to ensure consistency across all files.
   * This step helps prevent potential errors during data replacement, which could lead to incorrect insights in future analysis if mismatched values were treated as null.

5. Replace full names in the `sales_pipeline.csv` file with the corresponding sales agents, products, and accounts IDs. 
   * This transformation standardizes the data and facilitates efficient querying.

6. Save the updated data in the `sales_pipeline.csv` file
    * This final step ensures that the data is properly prepared and optimized for the next project phases.
  
Additionally, columns that contained empty string values were identified:

* `accounts.csv`: *subsidiary_of*.

* `sales_pipeline.csv`: *account*, *engage_date*, *close_date* and *close_value*.

#### Data Transformation Tools and Outputs

The data transformation process was automated using a Python script, which is available in the following Jupyter Notebook:

* [**csv_files_preparation.ipynb**](https://github.com/natalyamn/CRM_Sales_Opportunities_project/blob/main/1.%20Data%20Preparation/csv_files_preparation.ipynb)

The transformed data files resulting from this process can be found in the following directory:

* [**modified_files folder**](https://github.com/natalyamn/CRM_Sales_Opportunities_project/tree/main/1.%20Data%20Preparation/modified_files)
