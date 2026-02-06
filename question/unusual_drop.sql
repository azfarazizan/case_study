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
, week_on_time as (
    SELECT 
        week
        , account_tier
        , COUNT(is_on_time) AS total_is_on_time
    FROM base 
    where 1=1 
    AND is_on_time = 'true'
    GROUP BY week, account_tier
    ORDER BY WEEK ASC
)
, week_on_time_diff as (
    SELECT
        week
        , account_tier
        , total_is_on_time
        , total_is_on_time - LAG(total_is_on_time) OVER (PARTITION BY account_tier ORDER BY week) AS week_over_week_drop
    FROM
        week_on_time

)
SELECT 
	week
	, account_tier
	-- , total_is_on_time
	-- , week_over_week_drop
	, min(week_over_week_drop) as largest_drop_in_on_time
FROM week_on_time_diff 
GROUP BY week , account_tier,total_is_on_time
ORDER BY min(week_over_week_drop) asc 


---Results---
week	account_tier	largest_drop_in_on_time
50	    Silver	          -228
48	    Gold	          -204
51	    Gold	          -160
