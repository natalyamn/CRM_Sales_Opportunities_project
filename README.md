# CRM Sales Opportunities Project

### Dataset Description 
B2B sales pipeline data from a fictitious company that sells computer hardware, including information on accounts (companies), products, sales teams, and sales opportunities.

Details on Original Data Files and Modifications Done: [CSV files folder](https://github.com/natalyamn/CRM_Sales_Opportunities_project/tree/main/CSV%20files)

### Data Modeling

Database Management System (DBMS): MySQL 
* Database and Tables Creation & Data Loading: [db_creation_crm_sales.sql](https://github.com/natalyamn/CRM_Sales_Opportunities_project/blob/main/db_creation_crm_sales.sql)

#### Star schema structure
* Fact table:
  * sales:
    * opportunity_id - primary key (PK)
    * company_id, agent_id, product_id - foreign keys (FK)
      
* Dimension tables: many-to-one relationship with the fact table
  * companies: company_id - PK
  * sales_teams: agent_id - PK
  * products: product_id - PK

#### Entity-Relationship Diagram

![db_crm_sales_model](https://github.com/user-attachments/assets/190db539-a21c-44bb-bddf-99a1e4c5ddae)

### 

