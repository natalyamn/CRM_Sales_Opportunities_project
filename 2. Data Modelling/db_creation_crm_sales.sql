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

-- dimension table creation: accounts
CREATE TABLE IF NOT EXISTS accounts (
	account_id INT PRIMARY KEY,
    account_name VARCHAR(255) NOT NULL,
    sector VARCHAR(100) NOT NULL,
    year_established YEAR,
    revenue FLOAT,
    employees INT,
    office_location VARCHAR(100),
    subsidiary_of VARCHAR(255)
);

-- fact table creation: sales_pipeline 
CREATE TABLE IF NOT EXISTS sales_pipeline (
	opportunity_id VARCHAR(8) PRIMARY KEY,
    agent_id INT,
    product_id INT,
    account_id INT,
    deal_stage VARCHAR(50),
    engage_date DATE,
    close_date DATE,
    close_value FLOAT,
    FOREIGN KEY (agent_id) REFERENCES sales_teams(agent_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	FOREIGN KEY (account_id) REFERENCES accounts(account_id)
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

-- loading data into the accounts table - file: accounts.csv
LOAD DATA INFILE "C:\\DataFiles\\CRM_sales\\CSV files\\modified_files\\accounts.csv"
INTO TABLE accounts
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(account_id, account_name, sector, year_established, revenue, employees, office_location, @subsidiary_of)
SET subsidiary_of = NULLIF(@subsidiary_of,'');

SELECT * FROM accounts LIMIT 5;

-- loading data into the sales_pipeline table - file: sales_pipeline.csv
LOAD DATA INFILE "C:\\DataFiles\\CRM_sales\\CSV files\\modified_files\\sales_pipeline.csv"
INTO TABLE sales_pipeline
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(opportunity_id, agent_id, product_id, @account_id, deal_stage, @engage_date, @close_date, @close_value)
SET account_id = NULLIF(@account_id, ''),
	engage_date = NULLIF(@engage_date, ''),
    close_date = NULLIF(@close_date, ''),
    close_value = NULLIF(@close_value, '');

SELECT * FROM sales_pipeline LIMIT 5;