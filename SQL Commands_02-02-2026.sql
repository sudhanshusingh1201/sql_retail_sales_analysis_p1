/*SQL retail sales analysis-p1*/
create database project_p1;
use project_p1;
create table retail(user_id varchar(255));
drop table retail;
/*create table*/
create table retail_sales(
transactions_id	int primary key,
sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float
);
/*data cleaning*/
select * from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null 
or total_sale is null;
;
ALTER TABLE retail_sales
RENAME COLUMN quantiy TO quantity;
-- data exploration
-- how many sales we have?
select count(*) as total_sales from retail_sales;
-- how many  unique customer we have?
select count(distinct(customer_id)) as total_customer from retail_sales;
-- how many  unique category we have?
select distinct(category)from retail_sales;
-- data analysis and business key problem and answers
-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
select * from retail_sales
where sale_date = '2022-11-05';
-- 2.**Write a SQL query to retrieve all transactions where the category is 
-- 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
use project_p1;
SELECT *
FROM retail_sales
WHERE category = 'clothing'
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantity >= 4;
  --  3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
select category,
sum(total_sale)  as total_sale,
count(*) as total_orders
 from retail_sales
group by category;
-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
select category,
round(avg(age)) as avg_age from retail_sales
where category='beauty';
-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
select * from retail_sales
where total_sale> 1000;
SELECT gender, category, COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category;
-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
SELECT *
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY year, month
) AS t1
WHERE rnk = 1;
-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select customer_id,sum(total_sale) as total_sales  from retail_sales
group by customer_id
order by  total_sales desc limit 5;
-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
select category ,count(distinct(customer_id)) as unique_customer from retail_sales
group by category;
-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END as shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;
-- end of project
