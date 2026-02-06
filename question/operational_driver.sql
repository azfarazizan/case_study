-- 1. Does shipment mode impact late delivery rates?
WITH base AS (
    SELECT
        -- s.shipment_id
        -- , s.customer_id
        -- , s.shipment_date
        -- , EXTRACT(WEEK FROM shipment_date) week
         s.mode_of_shipment
        , s.reached_on_time_y_n
        , s.is_on_time
        , s.is_late
        -- , dc.customer_name
        -- , dc.customer_segment
        -- , dc.account_tier
        -- , dc.country_code
        -- , dc.region
    FROM
        fact_shipments s
    LEFT JOIN
        dim_customer dc ON s.customer_id = dc.customer_id
)
SELECT 
    mode_of_shipment,
    COUNT(*) AS total_shipments,
    COUNT(CASE WHEN is_on_time = 'true' THEN 1 END) AS on_time_shipments,
    COUNT(CASE WHEN is_late = 'true' THEN 1 END) AS late_shipments,
    ROUND(COUNT(CASE WHEN is_on_time = 'true' THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_on_time,
    ROUND(COUNT(CASE WHEN is_late = 'true' THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_late
FROM base 
GROUP BY mode_of_shipment

---Results--
mode_of_shipment	total_shipments	on_time_shipments	late_shipments	pct_on_time	pct_late
Ship	               7462	                4459	        3003        59.76   	40.24
Flight	               1777	                1069	        708	        60.16	    39.84
Road	               1760	                1035	        725	        58.81	    41.19

Shipment mode does affect the late deliveries late slightly
 - Flight has lowest percentage of late deliveries
 - Ship just slightly lowest percentage of late deliveries compared to Road



2.Does this vary by customer tier?
WITH base AS (
    SELECT
        s.shipment_id
        , s.customer_id
        , s.shipment_date
        , EXTRACT(WEEK FROM shipment_date) week
        , s.mode_of_shipment
        , s.is_late
        , dc.customer_name
        , dc.customer_segment
        , dc.account_tier
        , dc.country_code
        , dc.region
    FROM
        fact_shipments s
    LEFT JOIN
        dim_customer dc ON s.customer_id = dc.customer_id
)
SELECT 
    account_tier,
    mode_of_shipment,
    COUNT(*) AS total_shipments,
    COUNT(CASE WHEN is_late = 'true' THEN 1 END) AS late_shipments,
    ROUND(COUNT(CASE WHEN is_late = 'true' THEN 1 END) * 100.0 / COUNT(*), 2) AS pct_late
FROM base 
GROUP BY account_tier, mode_of_shipment
ORDER BY account_tier

---Results---
account_tier	mode_of_shipment	total_shipments	late_shipments	pct_late
Bronze	            Road	         352	          148	           42.05
Bronze	            Ship	         1494	          610	           40.83
Bronze	            Flight	         354	          155	           43.79
Gold	            Road	         704	          278	           39.49
Gold	            Flight	         711	          299	           42.05
Gold	            Ship	         2984	          1218	           40.82
Silver	            Flight	         712	          254	           35.67
Silver	            Road	         704	          299	           42.47
Silver	            Ship	         2984	          1175	           39.38


The late delivery rate do vary by customer tiers 
For flight mode, silver tiers show the lowest percentage of late delivery where bronze tiers is the highest.
Gold tiers just fall in between