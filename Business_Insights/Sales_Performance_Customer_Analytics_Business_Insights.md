# Sales Performance Customer Analytics
## Business Insights Report

**Author:** T. Sriram Reddy  
**Analysis tool:** MySQL  
**Primary tables:** `king` and `seller`

## Executive summary

The analysis shows a concentrated sales portfolio. DSLR Camera was the leading product by net sales, while a small group of products, sellers, and customers accounted for most of the value. This creates strong opportunities to protect high-performing areas, but it also creates dependency risk if demand, supply, or service quality weakens in those areas.

Cancellation analysis identified Laptop Stand and Monitor as products for investigation. Laptop Stand had a 75% cancellation rate from only four orders, so the percentage should not be generalized without more observations. Monitor had a 60% cancellation rate across five orders and ₹106,827.50 in sales value, making it a more commercially relevant investigation point. One missing payment-mode value was also identified as a data-quality issue.

## KPI definitions

- **Net sales** = `quantity × price_per_unit − quantity × price_per_unit × discount_percent / 100`
- **Realized sales** = net sales from non-cancelled orders
- **Average order value** = net sales divided by order count
- **Cancellation rate** = cancelled orders divided by total orders
- **Average delivery days** = average delivery date minus order date

## Key findings and actions

### 1. DSLR Camera was the highest-value product

**Evidence:** DSLR Camera generated ₹695,250 in net sales.  
**Business meaning:** High-value electronics demand is a major revenue driver.  
**Recommended action:** Protect inventory availability and monitor DSLR performance by city, seller, and customer.

### 2. Product revenue was highly concentrated

**Evidence:** The top five products contributed about 77.3% of total net sales.  
**Business meaning:** A small product group drives most commercial value, increasing both focus opportunity and portfolio risk.  
**Recommended action:** Maintain service levels for the leading products while developing secondary products to reduce dependency.

### 3. Seller revenue was highly concentrated

**Evidence:** The top five sellers contributed about 74.0% of total net sales.  
**Business meaning:** Seller capability and seller relationships have an outsized effect on overall performance.  
**Recommended action:** Compare seller net sales, AOV, cancellation rate, and delivery speed before allocating additional inventory or promotions.

### 4. Customer revenue was concentrated

**Evidence:** The top five customers contributed about 56.1% of total net sales.  
**Business meaning:** Retaining high-value customers is important, but the business should monitor concentration risk.  
**Recommended action:** Create retention and repeat-purchase actions for high-value customers and broaden the active customer base.

### 5. DSLR Camera demand was geographically concentrated

**Evidence:** Kolkata and Chennai were the leading locations for DSLR sales in the analysis.  
**Business meaning:** Location-specific demand may reflect customer mix, seller strength, inventory placement, or local promotion.  
**Recommended action:** Review stock allocation and marketing performance in the leading cities before expanding to weaker locations.

### 6. Laptop Stand had a high cancellation percentage but a small sample

**Evidence:** Laptop Stand showed a 75% cancellation rate across four orders.  
**Business meaning:** The rate is a warning signal, but four orders are not enough to establish a stable pattern.  
**Recommended action:** Inspect the individual orders and continue monitoring before making a broad product decision.

### 7. Monitor cancellation deserved investigation

**Evidence:** Monitor had a 60% cancellation rate across five orders and ₹106,827.50 in sales value.  
**Business meaning:** The cancellation issue has both a high rate and meaningful commercial exposure.  
**Recommended action:** Check stock availability, delivery promises, payment failures, and seller-level cancellation patterns.

### 8. Order volume did not necessarily equal revenue

**Evidence:** Backpack had many orders, while DSLR Camera generated much higher net sales.  
**Business meaning:** Order count alone can cause the business to overvalue low-ticket products.  
**Recommended action:** Use a scorecard combining orders, units, net sales, AOV, margin or discount, and cancellation rate.

### 9. Seller order count did not fully explain seller value

**Evidence:** Meena had fewer orders than some sellers but a high seller average order value.  
**Business meaning:** A seller with fewer transactions can still be commercially important if the basket value is high.  
**Recommended action:** Evaluate sellers using both productivity and value metrics rather than volume alone.

### 10. A missing payment mode was identified

**Evidence:** One row contained a `NULL` payment mode.  
**Business meaning:** Missing fields can weaken payment-method comparisons and downstream reporting.  
**Recommended action:** Add input validation, document the missing-value treatment, and correct the source record if possible.

## Recommendations

1. Prioritize DSLR Camera availability and city/seller monitoring.
2. Investigate Monitor cancellations immediately and review Laptop Stand at order level.
3. Use net sales and AOV alongside order volume in seller and product reviews.
4. Protect the top customer relationships while building broader demand.
5. Track realized sales separately from cancelled sales.
6. Add data-quality checks for payment mode and other required fields.
7. Review delivery performance by city, seller, category, and product as an operational KPI.

## Conclusion

The project demonstrates how SQL can move from raw order records to a business story. The strongest opportunity is to protect and scale high-value products and commercial relationships, while the strongest risk is concentration combined with cancellation and data-quality issues. A recurring dashboard using the same KPI definitions would help the business monitor whether the recommendations improve realized sales and operational reliability.
