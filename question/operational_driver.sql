1.
WITH base AS (
    SELECT
 	s.shipment_id
    , s.customer_id
    , s.shipment_date
	, EXTRACT(WEEK FROM shipment_date) week
     
    , s.warehouse_block
    , s.mode_of_shipment
    , s.product_importance
     
    , s.order_amount_local
    , s.currency_code
    , s.fx_to_usd
    , s.order_amount_usd
     
    , s.customer_care_calls
    , s.customer_rating
    , s.discount_offered
    , s.weight_in_gms
     
    , s.reached_on_time_y_n
	, s.is_on_time
	, s.is_late

    , dc.customer_name
    , dc.customer_segment
    , dc.account_tier
    , dc.country_code
    , dc.region
    , dc.currency_code
    FROM
        fact_shipments s
    LEFT JOIN
        dim_customer dc ON s.customer_id = dc.customer_id

)
SELECT 
    mode_of_shipment
    ,COUNT(*) AS total_shipments
    ,COUNT(CASE WHEN is_on_time = 'true' THEN 1 END) AS on_time_shipments
FROM base 
GROUP BY mode_of_shipment

---Results--
mode_of_shipment	total_shipments	on_time_shipments
Ship	               7462	            4459
Flight	               1777	            1069
Road	               1760	            1035


2.
WITH base AS (
    SELECT
 	s.shipment_id
    , s.customer_id
    , s.shipment_date
	, EXTRACT(WEEK FROM shipment_date) week
     
    , s.warehouse_block
    , s.mode_of_shipment
    , s.product_importance
     
    , s.order_amount_local
    , s.currency_code
    , s.fx_to_usd
    , s.order_amount_usd
     
    , s.customer_care_calls
    , s.customer_rating
    , s.discount_offered
    , s.weight_in_gms
     
    , s.reached_on_time_y_n
	, s.is_on_time
	, s.is_late

    , dc.customer_name
    , dc.customer_segment
    , dc.account_tier
    , dc.country_code
    , dc.region
    , dc.currency_code
    FROM
        fact_shipments s
    LEFT JOIN
        dim_customer dc ON s.customer_id = dc.customer_id

)
SELECT 
    account_tier
    ,mode_of_shipment
    ,COUNT(*) AS total_shipments
    ,COUNT(CASE WHEN is_late = 'true' THEN 1 END) AS late_shipments
FROM base 
GROUP BY account_tier, mode_of_shipment
ORDER BY account_tier

---Results---
account_tier mode_of_shipment total_shipments late_shipments
Bronze	            Flight	            354	        155
Bronze	            Road	            352	        148
Bronze	            Ship	            1494	    610
Gold	            Flight	            711	        299
Gold	            Road	            704	        278
Gold	            Ship	            2984	    1218
Silver	            Flight	            712	        254
Silver	            Road	            704	        299
Silver	            Ship	            2984	    1175

