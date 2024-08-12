# CRM Sales Opportunities Project

## Dataset Description 
B2B sales pipeline data from a fictitious company that sells computer hardware, including information on accounts (companies), products, sales teams, and sales opportunities.

## Objectives

* How is each sales team performing compared to the rest?

* Are any sales agents lagging behind?

* Can you identify any quarter-over-quarter trends?

* Do any products have better win rates?

## Project Phases
### Data Preparation
* Details on Original Data Files
* Modifications Done
### Data Modelling

### Data Analysis

### Report Creation

## Data Modelling

Database Management System (DBMS): MySQL 

##### Star schema structure
* Fact table:
  * sales:
    * opportunity_id - primary key (PK)
    * company_id, agent_id, product_id - foreign keys (FK)
      
* Dimension tables: many-to-one relationship with the fact table
  * companies: company_id - PK
  * sales_teams: agent_id - PK
  * products: product_id - PK

##### Entity-Relationship Diagram

![db_crm_sales_model](https://github.com/user-attachments/assets/190db539-a21c-44bb-bddf-99a1e4c5ddae)

#### Database and Tables Creation & Data Loading: [db_creation_crm_sales.sql](https://github.com/natalyamn/CRM_Sales_Opportunities_project/blob/main/db_creation_crm_sales.sql)

