#Create Database
CREATE DATABASE ecommerce_db;

#USE ecommerce_db;
Use ecommerce_db;

#Step 2: Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10),
    city VARCHAR(50),
    signup_date DATE
);

#Step 3: Create Products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

#📂 Step 4: Create Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

#Step 5: Create Order_Items Table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

#Step 6: Insert Sample Customers
INSERT INTO customers VALUES
(1,'Rahul','Male','Mumbai','2025-01-10'),
(2,'Priya','Female','Delhi','2025-01-15'),
(3,'Amit','Male','Pune','2025-02-01'),
(4,'Sneha','Female','Bangalore','2025-02-10'),
(5,'Rohan','Male','Hyderabad','2025-03-05');

#Step 7: Insert Sample Products 
INSERT INTO products VALUES
(101,'Laptop','Electronics',65000),
(102,'Headphones','Electronics',2500),
(103,'Office Chair','Furniture',7000),
(104,'Keyboard','Electronics',1800),
(105,'Water Bottle','Home',600);

#Step 8: Insert Sample Orders
INSERT INTO orders VALUES    
(1001,1,'2025-03-01','Delivered'),
(1002,2,'2025-03-03','Delivered'),
(1003,1,'2025-03-10','Delivered'),
(1004,3,'2025-03-15','Cancelled'),
(1005,4,'2025-03-20','Delivered');

#Step 9: Insert Sample Order Items
INSERT INTO order_items VALUES
(1,1001,101,1,65000),
(2,1001,102,2,2500),
(3,1002,103,1,7000),
(4,1003,104,1,1800),
(5,1004,105,3,600),
(6,1005,101,1,65000);


Select * from customers;
Select * from products;
Select * from orders ;
Select * from order_items;


# Business KPIs To Build
#Total Revenue

-- Total Orders
Select count(order_id) as Total_Orders_Recieved From orders;

-- Total Customers
Select count(distinct customer_id) as No_of_customer from Orders;

-- Average Order Value (AOV)
Select round(sum(quantity*unit_price) / count(distinct order_id),2) as AOV from order_items;

-- Revenue by Product Category
Select p.category, sum( quantity * unit_price) as Total_Revenue 
From Order_items ot 
Join products p ON ot.product_id = p.product_id
Group by p.category;

-- Monthly Sales Trend
Select month(order_date) as Months, sum( quantity * unit_price) as Total_Revenue 
From Order_items Ot
Join Orders o ON ot.order_id = o.order_id
Group by month(order_date);

-- Daily Sales Trend
Select day(order_date) as Months, sum( quantity * unit_price) as Total_Revenue 
From Order_items Ot
Join Orders o ON ot.order_id = o.order_id
Group by day(order_date);

-- Top 10 Selling Products
Select p.product_name, sum( quantity * unit_price) as Total_Revenue, sum(quantity) as Total_quantity_Sold
From Order_items ot 
Join products p ON ot.product_id = p.product_id
Group by product_name
Order by Total_Revenue Desc
Limit 10;

-- Top 10 Customers by Revenue
Select c.customer_name, sum(quantity * unit_price) as Total_Revenue
From Orders o
Join order_items ot ON o.order_id = ot.order_id
Join customers c ON o.customer_id = c.customer_id
Group by c.customer_name
Order by Total_Revenue Desc
Limit 10;

-- Revenue by City
Select c.city, sum(quantity * unit_price) as Total_Revenue
From Orders o
Join order_items ot ON o.order_id = ot.order_id
Join customers c ON o.customer_id = c.customer_id
Group by c.city
Order by Total_Revenue Desc;

-- Revenue by Gender
Select c.gender, sum(quantity * unit_price) as Total_Revenue
From Orders o
Join order_items ot ON o.order_id = ot.order_id
Join customers c ON o.customer_id = c.customer_id
Group by c.gender
Order by Total_Revenue Desc;

-- Customer Lifetime Value (CLV)
Select c.customer_name, sum(quantity * unit_price) as Total_Revenue
From Orders o
Join order_items ot ON o.order_id = ot.order_id
Right Join customers c ON o.customer_id = c.customer_id
Group by c.customer_name
Order by Total_Revenue Desc;

-- Customer Retention Rate
With Max_date as (
Select max(order_date) as Max_order_date
From Orders ),
current_month as (
Select distinct customer_id
from Orders
where date_format(order_date, '%Y-%m') = (Select date_format(Max_order_date, '%Y-%m') from Max_date) ),
previous_month as ( 
Select distinct customer_id
from Orders
where date_format(order_date, '%Y-%m') = (Select date_format(Max_order_date, '%Y-%m') from Max_date) - Interval 1 Month )
Select count(pm.customer_id) as customer_in_the_beginning,
	   count(cm.customer_id) as retained_customer,
       round(count(cm.customer_id) / count(pm.customer_id) * 100,2) as Customer_retention_rate
from previous_month pm
Left join current_month cm On pm.customer_id = cm.customer_id;

-- Customer Churn Rate
Select count(distinct customer_id) as Churn_cust, 
	   round(count(distinct customer_id) / (Select count(distinct customer_id) from customers) * 100.0, 2) as Cust_churn_rate
From Customers
Where Customer_id NOT IN (Select customer_id from Orders);

Select count(customer_id) as Cust_churn,
round(count(customer_id) * 100.0 / (select count(customer_id) from customers),1) as Churn_rate
From customers c
where not Exists ( Select 1 from orders o where o.customer_id = c.customer_id);

-- Average Products per Order
with total_orders as 
(Select 
order_id, sum(quantity * unit_price) as Total_revenue, sum(quantity) as Order_qty
From order_items
Group by Order_id )
Select round(avg(Total_revenue),2) as AOV, round(avg(Order_qty),0) as Avg_products_per_order From total_orders;

-- Repeat Purchase Rate
with repeat_purchase as (
Select customer_id, count(order_id) as od_cnt 
From Orders
Group by customer_id
having od_cnt > 1 )
Select round((count(customer_id) / (Select count(distinct customer_id) from customers)*100),0) as repeat_purchase_rate
From repeat_purchase;
-- Order Cancellation Rate
Select round(sum(case when order_status = 'Cancelled' then 1 else 0 end) * 100.0 / count(order_id),2) as Order_cancellation_rate
From orders;

-- Delivered vs Cancelled Orders
Select sum(case when order_status = 'Delivered' then 1 else 0 end) as Successful_orders,
	   sum(case when order_status = 'Cancelled' then 1 else 0 end) as Unsuccessful_orders
From Orders;

-- Best Selling Category
with best_category as (
Select p.category, sum(oi.quantity * oi.unit_price) as Revenue, sum(oi.quantity) as total_product_sold,
			       count(distinct oi.order_id) as Order_count
from order_items oi
Join products p Using(product_id)
Group by p.category
Order by Revenue desc
Limit 1 ) Select * from Best_Category;

-- Worst Selling Category
with Worst_category as (
Select p.category, sum(oi.quantity * oi.unit_price) as Revenue, sum(oi.quantity) as total_product_sold,
			       count(distinct oi.order_id) as Order_count
from order_items oi
Join products p Using(product_id)
Group by p.category
Order by Revenue asc
Limit 1 ) Select * from Worst_Category;


-- Most Expensive Product Sold
Select distinct p.product_name, oi.unit_price
From products p
Join order_items oi using(product_id)
Where oi.unit_price = (Select max(unit_price) from order_items);

-- Highest Revenue Month
select monthname(o.Order_date) as month, sum(oi.quantity * oi.unit_price) as Total_revenue 
From Order_items oi
Join orders o Using(order_id)
Group by monthname(o.order_date) 
Order by Total_revenue Desc 
Limit 1;
 
-- Customer Acquisition by Month
-- if customers has signup date column in Customer table then 
Select date_format(signup_date, '%Y-%m') as Month, 
count(customer_Id) as acq_cust 
From Customers 
Group by date_format(signup_date, '%Y-%m') 
Order by Month;

-- for customers in orders table 
With Min_order_date as
(Select customer_id, min(order_date) as Min_date From Orders Group by customer_id)
select date_format(Min_date, '%Y-%m') as Month, count(customer_id) as acq_cust 
From Min_Order_date 
group by date_format(Min_date, '%Y-%m');

-- New vs Returning Customers
Select max(order_date) into @cur_date from Orders;
with First_purchase_date as 
(Select customer_id, min(order_date) as Min_order_date
From orders
Group by customer_id),
current_month_customer as
(Select Distinct Customer_id
From orders
Where Date_format(order_date, '%Y-%m') = Date_format(@cur_date, '%Y-%m'))
Select sum(case when Date_format(fp.Min_order_date, '%Y-%m') = Date_format(@cur_date, '%Y-%m') Then 1 else 0 end) as New_Customer,
	   sum(case when Date_format(fp.Min_order_date, '%Y-%m') < Date_format(@cur_date, '%Y-%m') Then 1 else 0 end) as Returned_Customer
From current_month_customer cc
Join First_purchase_date fp ON cc.customer_id = fp.customer_id;

-- Category-wise Revenue Contribution
with category_sales as 
(Select p.category, sum(oi.quantity * oi.unit_Price) as Revenue
From products p
Join order_items oi On p.product_id = oi.product_id Group by p.category)
select category, Round((Revenue / sum(revenue) over()) * 100.0,1) as Contribution
from category_sales;