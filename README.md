# Sales Performance Customer Analytics

A MySQL portfolio project that analyzes orders, products, customers, cities, sellers, payment methods, discounts, cancellations, and delivery performance.

## Project overview

This project turns transaction-level sales data into business insights that can support product planning, seller management, cancellation reduction, delivery monitoring, and customer prioritization.

The analysis uses two related tables:

- `king`: order-level sales and delivery data
- `seller`: seller lookup data joined through `seller_id`

## Business problem

A sales team needs to understand what is driving net sales, where revenue is concentrated, which products and sellers need attention, how cancellations affect realized revenue, and whether operational performance differs by city, category, seller, or payment mode.

## Dataset structure

### `king` table

| Column | Purpose |
|---|---|
| `order_id` | Unique order identifier |
| `order_date` | Order date |
| `delivery_date` | Delivery date |
| `customer_name` | Customer identifier/name |
| `city` | Customer or order city |
| `main_products` | Product name |
| `category` | Product category |
| `quantity` | Units ordered |
| `price_per_unit` | Unit selling price |
| `discount_percent` | Discount applied to the order line |
| `order_status` | Order state, including cancelled orders |
| `payment_mode` | Payment method |
| `seller_id` | Foreign key to `seller` |

### `seller` table

| Column | Purpose |
|---|---|
| `seller_id` | Seller identifier |
| `seller_name` | Seller name |

## Key KPI definitions

- **Gross sales:** `quantity × price_per_unit`
- **Discount value:** `quantity × price_per_unit × discount_percent / 100`
- **Net sales:** gross sales minus discount value
- **Realized sales:** net sales from non-cancelled orders
- **Average order value:** net sales divided by order count
- **Cancellation rate:** cancelled orders divided by total orders
- **Average delivery days:** average of `DATEDIFF(delivery_date, order_date)`

## SQL analysis performed

The project contains 30 named queries in [`Sales_Performance_Customer_Analytics.sql`](Sales_Performance_Customer_Analytics.sql), covering:

1. Overall order, quantity, gross sales, discount, net sales, and average-order-value metrics
2. City-level sales and average-order-value comparisons
3. Product, category, and electronics performance
4. Top-customer and customer-concentration analysis
5. Seller revenue, seller AOV, seller concentration, and delivery performance
6. Order-status, product, city, and payment-mode cancellation analysis
7. Realized versus cancelled sales value
8. Monthly sales trends
9. DSLR Camera sales by city and seller
10. Data-quality checks, including missing payment modes

## Key business insights

The completed analysis established these findings:

| Finding | Evidence / interpretation |
|---|---|
| DSLR Camera was the strongest product by net sales | ₹695,250 in net sales |
| Revenue was concentrated among a few products | The top five products contributed about 77.3% of total net sales |
| Revenue was concentrated among a few sellers | The top five sellers contributed about 74.0% of total net sales |
| Customer concentration was material | The top five customers contributed about 56.1% of total net sales |
| DSLR sales were geographically concentrated | Kolkata and Chennai were the leading DSLR locations in the analysis |
| Laptop Stand showed a high cancellation rate | 75% cancellation rate, based on only four orders; the small sample should be considered |
| Monitor required investigation | 60% cancellation rate across five orders and ₹106,827.50 in sales value |
| Order count was not the same as revenue impact | Backpack generated many orders, while DSLR Camera generated much higher revenue |
| Seller order volume alone was not enough to explain performance | Meena had fewer orders than some sellers but a high seller average order value |
| Data quality needed documentation | One row had a `NULL` payment mode |

## Recommendations

1. Protect DSLR Camera availability and monitor its seller and city performance closely.
2. Review the cancellation drivers for Laptop Stand and Monitor, while separating high rates caused by small samples from scalable issues.
3. Use seller-level net sales and AOV together instead of ranking sellers only by order count.
4. Build customer-retention actions for the highest-value customers because revenue concentration creates dependency risk.
5. Investigate the operational reasons behind city-level concentration and delivery-time differences.
6. Add validation rules for required fields such as `payment_mode`, and document how missing values are handled.
7. Track realized sales rather than gross sales when evaluating business performance.

## SQL skills demonstrated

- Aggregations with `sum`, `count`, and `avg`
- Calculated metrics and financial formulas
- `case when` conditional logic
- `inner join` between order and seller tables
- `group by`, `having`-style analytical thinking, `order by`, and `limit`
- Subqueries for contribution and concentration analysis
- Date functions including `date_format` and `datediff`
- Null-safe calculations with `nullif`
- Cancellation-rate and data-quality analysis
- Business interpretation of SQL outputs

## Repository structure

```text
Sales-Performance-Customer-Analytics/
├── Sales_Performance_Customer_Analytics.sql
├── README.md
├── data/
│   └── README.md
├── Business_Insights/
│   ├── Sales_Performance_Customer_Analytics_Business_Insights.md
│   ├── Sales_Performance_Customer_Analytics_Business_Insights.pdf
│   └── Sales_Performance_Customer_Analytics_Business_Insights_Professional.docx
└── screenshots/
    └── README.md
```

## How to run

1. Create or select a MySQL 8+ database.
2. Load the `king` and `seller` tables using your dataset import process.
3. Open `Sales_Performance_Customer_Analytics.sql` in MySQL Workbench, DBeaver, or another MySQL client.
4. Run the data-quality check first, then execute the KPI and analysis queries.
5. Compare the results with the business insights report.

The SQL file is intentionally written with lowercase SQL keywords, descriptive query headings, and consistent separators so each analysis can be reviewed independently.

## Portfolio outcome

This project demonstrates an end-to-end analyst workflow: define business questions, calculate KPIs, segment performance, identify concentration and operational risks, check data quality, and translate SQL results into recommendations.

## Author

**T. Sriram Reddy**
