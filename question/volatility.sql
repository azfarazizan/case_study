WITH customer_on_time AS (
    SELECT 
        customer_id
        -- DATE_TRUNC('month', shipment_date) AS month,  
        , reached_on_time_y_n 
    FROM 
        fact_shipments
),
customer_volatility AS (
    SELECT
        customer_id
        -- month,  
        , COUNT(CASE WHEN reached_on_time_y_n = 1 THEN 1 END) AS on_time_count
        , COUNT(CASE WHEN reached_on_time_y_n = 0 THEN 1 END) AS late_count
        , STDDEV(reached_on_time_y_n::int) AS delivery_volatility
    FROM 
        customer_on_time
    GROUP BY
        customer_id  
)
SELECT 
    customer_id
    -- month,  
    , delivery_volatility
    , on_time_count
    , late_count
FROM 
    customer_volatility
ORDER BY 
    delivery_volatility DESC;
