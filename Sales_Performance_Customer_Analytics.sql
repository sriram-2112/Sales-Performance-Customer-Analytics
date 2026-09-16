-- Sales Performance Customer Analytics
-- Author: T. Sriram Reddy
-- Dialect: MySQL 8+
--
-- Notes:
--   * Primary fact table: king
--   * Seller lookup table: seller
--   * Net sales = quantity * price_per_unit
--                 - quantity * price_per_unit * discount_percent / 100
--   * Cancelled orders are excluded from realized-sales analysis where noted.
--   * Run the data-quality checks before relying on the results.

-- 01. Dataset row count
--------------------------------------------------------------------------------
select count(*) as total_orders
from king;

-- 02. Total quantity sold
--------------------------------------------------------------------------------
select sum(quantity) as total_quantity
from king;

-- 03. Gross sales before discount
--------------------------------------------------------------------------------
select sum(quantity * price_per_unit) as gross_sales
from king;

-- 04. Total discount value
--------------------------------------------------------------------------------
select sum(quantity * price_per_unit * discount_percent / 100) as total_discount
from king;

-- 05. Net sales after discount
--------------------------------------------------------------------------------
select sum(quantity * price_per_unit)
       - sum(quantity * price_per_unit * discount_percent / 100) as net_sales
from king;

-- 06. Average order value
--------------------------------------------------------------------------------
select round(
           (
             sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100)
           ) / nullif(count(*), 0),
           2
       ) as average_order_value
from king;

-- 07. Sales by city
--------------------------------------------------------------------------------
select city,
       count(*) as total_orders,
       sum(quantity) as total_quantity,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales
from king
where order_status <> 'Cancelled'
group by city
order by net_sales desc;

-- 08. Sales and average order value by city
--------------------------------------------------------------------------------
select city,
       count(*) as total_orders,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales,
       round(
           (
             sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100)
           ) / nullif(count(*), 0),
           2
       ) as average_order_value
from king
where order_status <> 'Cancelled'
group by city
order by net_sales desc;

-- 09. Mumbai product performance
--------------------------------------------------------------------------------
select main_products,
       count(*) as total_orders,
       sum(quantity) as total_quantity,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales,
       round(avg(discount_percent), 2) as average_discount_percent
from king
where city = 'Mumbai'
  and order_status <> 'Cancelled'
group by main_products
order by net_sales desc;

-- 10. Mumbai category performance
--------------------------------------------------------------------------------
select category,
       count(*) as total_orders,
       sum(quantity) as total_quantity,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales,
       round(avg(discount_percent), 2) as average_discount_percent
from king
where city = 'Mumbai'
  and order_status <> 'Cancelled'
group by category
order by net_sales desc;

-- 11. Top five customers by net sales
--------------------------------------------------------------------------------
select customer_name,
       count(*) as total_orders,
       sum(quantity) as total_quantity,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales
from king
where order_status <> 'Cancelled'
group by customer_name
order by net_sales desc
limit 5;

-- 12. Top customers by average order value
--------------------------------------------------------------------------------
select customer_name,
       count(*) as total_orders,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales,
       round(
           (
             sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100)
           ) / nullif(count(*), 0),
           2
       ) as average_order_value
from king
where order_status <> 'Cancelled'
group by customer_name
order by average_order_value desc
limit 10;

-- 13. Customer concentration in total net sales
--------------------------------------------------------------------------------
select customer_name,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as customer_net_sales,
       round(
           (
             sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100)
           ) / nullif(
                 (select sum(quantity * price_per_unit)
                        - sum(quantity * price_per_unit * discount_percent / 100)
                  from king
                  where order_status <> 'Cancelled'),
                 0
               ) * 100,
           2
       ) as sales_percentage
from king
where order_status <> 'Cancelled'
group by customer_name
order by sales_percentage desc
limit 5;

-- 14. Seller performance
--------------------------------------------------------------------------------
select s.seller_name,
       count(*) as total_orders,
       sum(k.quantity) as total_quantity,
       round(sum(k.quantity * k.price_per_unit)
             - sum(k.quantity * k.price_per_unit * k.discount_percent / 100), 2) as net_sales,
       round(
           (
             sum(k.quantity * k.price_per_unit)
             - sum(k.quantity * k.price_per_unit * k.discount_percent / 100)
           ) / nullif(count(*), 0),
           2
       ) as seller_average_order_value
from king k
inner join seller s
        on s.seller_id = k.seller_id
where k.order_status <> 'Cancelled'
group by s.seller_id, s.seller_name
order by net_sales desc;

-- 15. Seller concentration in total net sales
--------------------------------------------------------------------------------
select s.seller_name,
       round(sum(k.quantity * k.price_per_unit)
             - sum(k.quantity * k.price_per_unit * k.discount_percent / 100), 2) as seller_net_sales,
       round(
           (
             sum(k.quantity * k.price_per_unit)
             - sum(k.quantity * k.price_per_unit * k.discount_percent / 100)
           ) / nullif(
                 (select sum(quantity * price_per_unit)
                        - sum(quantity * price_per_unit * discount_percent / 100)
                  from king
                  where order_status <> 'Cancelled'),
                 0
               ) * 100,
           2
       ) as sales_percentage
from king k
inner join seller s
        on s.seller_id = k.seller_id
where k.order_status <> 'Cancelled'
group by s.seller_id, s.seller_name
order by sales_percentage desc
limit 5;

-- 16. Seller delivery performance
--------------------------------------------------------------------------------
select s.seller_name,
       count(*) as total_orders,
       round(avg(datediff(k.delivery_date, k.order_date)), 2) as average_delivery_days
from king k
inner join seller s
        on s.seller_id = k.seller_id
group by s.seller_id, s.seller_name
order by average_delivery_days asc;

-- 17. Delivery performance by category
--------------------------------------------------------------------------------
select category,
       count(*) as total_orders,
       round(avg(datediff(delivery_date, order_date)), 2) as average_delivery_days
from king
group by category
order by average_delivery_days desc;

-- 18. Delivery performance by city
--------------------------------------------------------------------------------
select city,
       count(*) as total_orders,
       round(avg(datediff(delivery_date, order_date)), 2) as average_delivery_days
from king
group by city
order by average_delivery_days desc;

-- 19. Overall order-status performance
--------------------------------------------------------------------------------
select order_status,
       count(*) as total_orders,
       sum(quantity) as total_quantity,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as sales_value
from king
group by order_status
order by sales_value desc;

-- 20. Cancellation rate by city
--------------------------------------------------------------------------------
select city,
       count(*) as total_orders,
       sum(case when order_status = 'Cancelled' then 1 else 0 end) as cancelled_orders,
       round(
           sum(case when order_status = 'Cancelled' then 1 else 0 end)
           * 100.0 / nullif(count(*), 0),
           2
       ) as cancellation_rate
from king
group by city
order by cancellation_rate desc;

-- 21. Cancellation rate by product
--------------------------------------------------------------------------------
select main_products,
       count(*) as total_orders,
       sum(case when order_status = 'Cancelled' then 1 else 0 end) as cancelled_orders,
       round(
           sum(case when order_status = 'Cancelled' then 1 else 0 end)
           * 100.0 / nullif(count(*), 0),
           2
       ) as cancellation_rate,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as sales_value
from king
group by main_products
order by cancellation_rate desc;

-- 22. Realized versus cancelled sales value
--------------------------------------------------------------------------------
select round(sum(case
                     when order_status <> 'Cancelled'
                     then quantity * price_per_unit
                          - quantity * price_per_unit * discount_percent / 100
                     else 0
                 end), 2) as realized_sales,
       round(sum(case
                     when order_status = 'Cancelled'
                     then quantity * price_per_unit
                          - quantity * price_per_unit * discount_percent / 100
                     else 0
                 end), 2) as cancelled_sales_value
from king;

-- 23. Monthly sales trend for non-cancelled orders
--------------------------------------------------------------------------------
select date_format(order_date, '%Y-%m') as month,
       count(*) as total_orders,
       sum(quantity) as total_quantity,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales
from king
where order_status <> 'Cancelled'
group by date_format(order_date, '%Y-%m')
order by month;

-- 24. Payment-mode performance
--------------------------------------------------------------------------------
select payment_mode,
       count(*) as total_orders,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales,
       round(
           (
             sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100)
           ) / nullif(count(*), 0),
           2
       ) as average_order_value
from king
where order_status <> 'Cancelled'
group by payment_mode
order by net_sales desc;

-- 25. Payment-mode cancellation rate
--------------------------------------------------------------------------------
select payment_mode,
       count(*) as total_orders,
       sum(case when order_status = 'Cancelled' then 1 else 0 end) as cancelled_orders,
       round(
           sum(case when order_status = 'Cancelled' then 1 else 0 end)
           * 100.0 / nullif(count(*), 0),
           2
       ) as cancellation_rate
from king
group by payment_mode
order by cancellation_rate desc;

-- 26. Category performance
--------------------------------------------------------------------------------
select category,
       count(*) as total_orders,
       sum(quantity) as total_quantity,
       round(avg(discount_percent), 2) as average_discount_percent,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales,
       round(
           (
             sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100)
           ) / nullif(count(*), 0),
           2
       ) as category_average_order_value
from king
where order_status <> 'Cancelled'
group by category
order by net_sales desc;

-- 27. Electronics product performance
--------------------------------------------------------------------------------
select main_products,
       count(*) as total_orders,
       sum(quantity) as total_quantity,
       round(avg(price_per_unit), 2) as average_price,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales
from king
where category = 'Electronics'
  and order_status <> 'Cancelled'
group by main_products
order by net_sales desc;

-- 28. DSLR Camera sales by city
--------------------------------------------------------------------------------
select city,
       count(*) as total_orders,
       sum(quantity) as total_quantity,
       round(sum(quantity * price_per_unit)
             - sum(quantity * price_per_unit * discount_percent / 100), 2) as net_sales
from king
where main_products = 'DSLR Camera'
  and order_status <> 'Cancelled'
group by city
order by net_sales desc;

-- 29. DSLR Camera sales by seller
--------------------------------------------------------------------------------
select s.seller_name,
       count(*) as total_orders,
       sum(k.quantity) as total_quantity,
       round(sum(k.quantity * k.price_per_unit)
             - sum(k.quantity * k.price_per_unit * k.discount_percent / 100), 2) as net_sales
from king k
inner join seller s
        on s.seller_id = k.seller_id
where k.main_products = 'DSLR Camera'
  and k.order_status <> 'Cancelled'
group by s.seller_id, s.seller_name
order by net_sales desc;

-- 30. Data-quality check: missing payment modes
--------------------------------------------------------------------------------
select count(*) as missing_payment_mode_rows
from king
where payment_mode is null;
