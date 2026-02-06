CREATE TABLE dim_customer AS
SELECT
     customer_id
    , customer_name
    , customer_segment
    , account_tier
    , country_code
    , region
    , currency_code
FROM customer_stg

--PK Uniqueness Check
SELECT customer_id , count(*) 
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1