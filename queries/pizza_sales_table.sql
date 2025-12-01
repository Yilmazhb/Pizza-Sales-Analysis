USE Pizza;

-- Create table with correct data types
CREATE TABLE pizza_sales (
    pizza_id DECIMAL(10,2) NOT NULL,
    order_id DECIMAL(10,2) NOT NULL,
    pizza_name_id VARCHAR(50) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    pizza_size VARCHAR(5) NOT NULL,
    pizza_category VARCHAR(50) NOT NULL,
    pizza_ingredients VARCHAR(500) NOT NULL,
    pizza_name VARCHAR(100) NOT NULL
);
GO

-- Temporary staging table for import (with string data types)
CREATE TABLE pizza_sales_staging (
    pizza_id DECIMAL(10,2),
    order_id DECIMAL(10,2),
    pizza_name_id VARCHAR(50),
    quantity DECIMAL(10,2),
    order_date_string VARCHAR(20),
    order_time_string VARCHAR(20),
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    pizza_size VARCHAR(5),
    pizza_category VARCHAR(50),
    pizza_ingredients VARCHAR(500),
    pizza_name VARCHAR(100)
);
GO

-- Import data into staging table
BULK INSERT pizza_sales_staging
FROM 'C:\pizza_sales.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001' -- UTF-8
);
GO

-- Transfer data from staging to main table with correct date/time conversion
INSERT INTO pizza_sales (
    pizza_id, order_id, pizza_name_id, quantity, 
    order_date, order_time, unit_price, total_price, 
    pizza_size, pizza_category, pizza_ingredients, pizza_name
)
SELECT 
    pizza_id,
    order_id,
    pizza_name_id,
    quantity,
    -- Convert date (format: dd/mm/yyyy)
    CASE 
        WHEN ISDATE(order_date_string) = 1 THEN CAST(order_date_string AS DATE)
        ELSE TRY_CAST(SUBSTRING(order_date_string, 4, 2) + '/' + 
                     SUBSTRING(order_date_string, 1, 2) + '/' + 
                     SUBSTRING(order_date_string, 7, 4) AS DATE)
    END AS order_date,
    -- Convert time
    CASE 
        WHEN ISDATE(order_time_string) = 1 THEN CAST(order_time_string AS TIME)
        ELSE TRY_CAST(order_time_string AS TIME)
    END AS order_time,
    unit_price,
    total_price,
    pizza_size,
    pizza_category,
    pizza_ingredients,
    pizza_name
FROM pizza_sales_staging;
GO

-- Clean up staging table
DROP TABLE pizza_sales_staging;
GO



