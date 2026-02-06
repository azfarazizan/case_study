# Overview

This project transforms raw operational data into an analytics-ready dimensional model that enables stakeholders to:

- Monitor delivery performance
- Identify unusual drops in shipment volume
- Detect volatile customers or service patterns
- Compare operational performance across customer segments

---

# Solution 


---

## 1. RAW Layer
- Load all source data
- Preserve all raw data without modification
- All columns stored as `TEXT` data type

---

## 2. STAGING Layer (Transformation)

### Data Type Conversion
- Cast all columns into appropriate data types (e.g. `INT`, `DECIMAL`)

### Date Parsing
- Standardize date format into `YYYY-MM-DD`
- Makes it easier to apply date functions later

### Quick Data Validation
- Compare record counts before and after transformation

---

## 3. MARTS Layer

### DIM_CUSTOMER
- One row per customer
- **Grain:** `customer_id`

### FACT_SHIPMENTS
- One row per shipment
- **Grain:** `shipment_id`, `warehouse_block`

#### Contains:
- Derived fields:
  - `is_on_time`: boolean flag  
    ```sql
    CASE WHEN reached_on_time_y_n = 1 THEN TRUE ELSE FALSE
    ```
  - `is_late`: boolean flag  
    ```sql
    CASE WHEN reached_on_time_y_n = 0 THEN TRUE ELSE FALSE
    ```
  - `amount_usd`: normalized monetary value (local amount × FX rate)
- Foreign key:
  - `customer_id`

---

## Data Quality Fixes (Staging Layer)

### 1. Shipments
- Replace invalid character in numeric field:
  ```sql
  REPLACE(order_amount_local, 'O', '0')
### 2. Fxrates
- Replace Replace invalid decimal separator:
  ```sql
    REPLACE(order_amount_local, 'O', '0')
### 3. Customer
- Have value but not column name
- Update the column assume as currency_code (assumption but would clarify with stakeholders if needed)
### 4. Currency Normalization
- Replace invalid character in numeric field:
  ```sql
    s.order_amount_local * fx.fx_to_usd AS amount_usd

## BUSINESS QUESTION
 1. Unusual Drops
- Which customer tiers experienced the largest week-over-week drop in on-time shipments?
2. Volatility
- Which customers show the most volatility in on-time delivery performance?
3. Operational Driver
- Does shipment mode impact late delivery rates?
- Does this vary by customer tier?
