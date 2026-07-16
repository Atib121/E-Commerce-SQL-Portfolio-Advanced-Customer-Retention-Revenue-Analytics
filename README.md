# E-Commerce Data Architecture & Business Intelligence Analytics

## 📌 Project Overview
This project demonstrates the design, implementation, and analysis of a relational database for an e-commerce platform using MySQL. The objective was to move beyond simple data retrieval and construct an enterprise-level analytics script capable of extracting critical Business Performance KPIs, Customer Cohort Behaviors, and Demographics Trends from historical transaction logs.

## 🗄️ Relational Database Schema
The database consists of four core tables structured to maintain transactional integrity and relational mapping:
* **`customers`**: Tracks user profiles, demographics (gender, city), and account creation timestamps.
* **`products`**: Inventory catalog tracking item nomenclature, categorization, and base unit pricing.
* **`orders`**: High-level transaction logs monitoring checkout timestamps and delivery execution status.
* **`order_items`**: Granular breakdown of individual shopping baskets, mapping quantity volumes and historical unit prices per line item.

---

## 📈 Key Business Insights & Advanced Analytics Solved

The analytical script is engineered to extract insights across four major corporate functions:

### 1. Retention & Customer Behavior Metrics
* **Customer Retention Rate (CRR):** Tracks month-over-month active user retention by mapping historical consumer activity windows.
* **True Churn Analysis:** Developed using highly optimized **Correlated Subqueries (`NOT EXISTS`)** to identify zero-transaction users without dropping performance on massive tables.
* **New vs. Returning Shoppers:** Utilizes a windowing methodology to check customer "birthdays" against current transaction months to map monthly growth profiles.
* **Customer Lifetime Value (CLV):** Ranks historical consumer value across their transactional lifespan.

### 2. Demographic & Segmentation Analytics
* **Revenue by City & Gender:** Pinpoints geographic and demographic revenue concentrations to assist marketing optimization.
* **Top 10 High-Value Customers:** Aggregates order item variables to track brand advocate purchasing thresholds.

### 3. Financial & Trend Analysis
* **Average Order Value (AOV):** Aggregated at the unique invoice level to understand structural consumer basket sizes.
* **Category Revenue Contribution:** Implemented **Window Functions (`SUM() OVER()`)** to build self-balancing percentage contributions per product category.
* **Daily & Monthly Sales Trends:** Provides historical macro overviews of velocity and transaction health over time.

### 4. Operational & Inventory Efficiency
* **Top 10 Selling Products:** Tracks product volume against total revenue generation.
* **Product Performance Matrix:** Highlights underperforming categories based on multi-metric parameters (Revenue vs. Volume vs. Transaction Count).
* **Order Cancellation Rate:** Monitors successful fulfillment ratios using conditional aggregation methods.

---

## 🚀 Technical Skills Demonstrated
* **Advanced DDL & DML:** Schema generation, strict primary/foreign key constraint assignments, and transactional mock data design.
* **Common Table Expressions (CTEs):** Structured multi-stage analytical processes for high readability and modularity.
* **Window Functions:** Implemented specialized database tools (`OVER()`) to calculate dynamic running totals and benchmarks without dual-scanning heavy data tables.
* **Query Optimization:** Replaced slow conditional logic (like `NOT IN` subqueries) with index-friendly anti-joins to ensure the scripts handle multi-year scalability seamlessly.

---

## 🛠️ How To Use This Repository
1. Clone the repository to your local system.
2. Run the schema creation script to set up `ecommerce_db` and populate the tables with sample records.
3. Execute the analytical KPI queries to generate the management reporting metrics.

*Next phase of this project involves connecting this schema to a business intelligence tool (Power BI/Excel) to engineer automated data dashboards.*
