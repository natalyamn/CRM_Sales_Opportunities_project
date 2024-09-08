# Data Modelling

## Star Schema Structure

In this project, I used a star schema structure to organize the data for efficient querying and analysis.

#### Fact table

* **sales_pipeline**
  
  * *opportunity_id*: The primary key (PK) for the fact table, uniquely identifying each sales opportunity.
  * *account_id*: A foreign key (FK) linking to the accounts dimension table, identifying the company involved in the sales opportunity.
  * *agent_id*: A foreign key (FK) linking to the sales_teams dimension table, identifying the sales agent responsible for the opportunity.
  * *product_id*: A foreign key (FK) linking to the products dimension table, identifying the product involved in the sales opportunity.
      
#### Dimension tables

Each dimension table has a many-to-one relationship with the fact table, meaning multiple records in the fact table can relate to a single record in a dimension table.

* **accounts**:

  * *account_id*: The primary key (PK) that uniquely identifies each company.

* **sales_teams**:

  * *agent_id*: The primary key (PK) that uniquely identifies each sales agent or team member.

* **products**:

  * *product_id*: The primary key (PK) that uniquely identifies each product.

## Database and Tables Creation

I designed and implemented the database in MySQL, where I created each table (fact and dimension) based on the schema defined above. The creation process involved:

* Defining the tables: I used SQL scripts to create the sales_pipeline, accounts, sales_teams, and products tables, specifying the appropriate data types and constraints (e.g., primary keys, foreign keys, NOT NULL).

* Establishing relationships: I set up foreign key constraints to enforce referential integrity between the fact and dimension tables.

The SQL script I used for this process is available here: [**db_creation_crm_sales.sql**](https://github.com/natalyamn/CRM_Sales_Opportunities_project/blob/main/2.%20Data%20Modelling/db_creation_crm_sales.sql)

## Data Loading 

Once the tables were created, I proceeded to load the data into the database.

* Data Import: I imported the raw data (transformed during the Data Preparation phase) into the MySQL database using SQL commands. During this process, I ensured the data was correctly mapped to the corresponding columns in the tables.

* Data Integrity: For columns with empty string records (identified during the Data Preparation phase), I converted those to NULL values to accurately represent missing data.

The SQL script for data loading can also be found here: [**db_creation_crm_sales.sql**](https://github.com/natalyamn/CRM_Sales_Opportunities_project/blob/main/2.%20Data%20Modelling/db_creation_crm_sales.sql)

## Entity-Relationship Diagram

The following Entity-Relationship Diagram (ERD) visually represents the star schema structure, providing a clear overview of the database architecture and the relationships between entities.

![db_crm_sales_diagram](https://github.com/user-attachments/assets/6e8e2d0b-350a-4952-a035-839b967d9247)
