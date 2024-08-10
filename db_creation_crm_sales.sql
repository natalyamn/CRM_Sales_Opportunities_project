-- database creation
CREATE DATABASE IF NOT EXISTS crm_sales;
USE crm_sales;

-- dimension table creation: sales_teams
CREATE TABLE IF NOT EXISTS sales_teams (
	agent_id INT PRIMARY KEY,
    sales_agent VARCHAR(100) NOT NULL,
    manager VARCHAR(100),
    regional_office VARCHAR(20)
);

-- dimension table creation: products
CREATE TABLE IF NOT EXISTS products (
	product_id INT PRIMARY KEY,
    product_name VARCHAR(25) NOT NULL,
    series VARCHAR(10) NOT NULL,
    sales_price INT NOT NULL
);

-- dimension table creation: companies
CREATE TABLE IF NOT EXISTS companies (
	company_id INT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    sector VARCHAR(100) NOT NULL,
    year_established YEAR,
    revenue FLOAT,
    employees INT,
    office_location VARCHAR(100),
    subsidiary_of VARCHAR(255)
);

-- fact table creation: sales 
CREATE TABLE IF NOT EXISTS sales (
	opportunity_id VARCHAR(8) PRIMARY KEY,
    agent_id INT,
    product_id INT,
    company_id INT,
    deal_stage VARCHAR(50),
    engage_date DATE,
    close_date DATE,
    close_value FLOAT,
    FOREIGN KEY (agent_id) REFERENCES sales_teams(agent_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	FOREIGN KEY (company_id) REFERENCES companies(company_id)
);

---------------------------------------------------------------------------------------------------

-- loading data into the sales_teams table - file: sales_teams.csv 
LOAD DATA INFILE "C:\\DataFiles\\CRM_sales\\CSV files\\modified_files\\sales_teams.csv"
INTO TABLE sales_teams
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT * FROM sales_teams LIMIT 5;

-- loading data into the products table - file: products.csv
LOAD DATA INFILE "C:\\DataFiles\\CRM_sales\\CSV files\\modified_files\\products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT * FROM products LIMIT 5;

-- loading data into the companies table - file: accounts.csv
LOAD DATA INFILE "C:\\DataFiles\\CRM_sales\\CSV files\\modified_files\\accounts.csv"
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(company_id, company_name, sector, year_established, revenue, employees, office_location, @subsidiary_of)
SET subsidiary_of = NULLIF(@subsidiary_of,'');

SELECT * FROM companies LIMIT 5;

-- loading data into the sales table - file: sales_pipeline.csv
LOAD DATA INFILE "C:\\DataFiles\\CRM_sales\\CSV files\\modified_files\\sales_pipeline.csv"
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(opportunity_id, agent_id, product_id, @company_id, deal_stage, @engage_date, @close_date, @close_value)
SET company_id = NULLIF(@company_id, ''),
	engage_date = NULLIF(@engage_date, ''),
    close_date = NULLIF(@close_date, ''),
    close_value = NULLIF(@close_value, '');

SELECT * FROM sales LIMIT 5;