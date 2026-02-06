CREATE TABLE fact_shipments AS
SELECT
      s.shipment_id
    , s.customer_id
    , s.shipment_date
     
    , s.warehouse_block
    , s.mode_of_shipment
    , s.product_importance
     
    , s.order_amount_local
    , s.currency_code
    , fx.fx_to_usd
    , s.order_amount_local * fx.fx_to_usd AS order_amount_usd
     
    , s.customer_care_calls
    , s.customer_rating
    , s.discount_offered
    , s.weight_in_gms
     
    , s.reached_on_time_y_n
	, CASE WHEN s.reached_on_time_y_n = 1 THEN TRUE ELSE FALSE END AS is_on_time
	, CASE WHEN s.reached_on_time_y_n = 0 THEN TRUE ELSE FALSE END AS is_late
    
FROM shipments_stg s
LEFT JOIN fxrates_stg fx
    ON s.currency_code = fx.quote_currency
    AND s.shipment_date = fx.rate_date


--Ensure fxrates unique
SELECT quote_currency, rate_date, COUNT(*)
FROM fxrates_stg
GROUP BY quote_currency, rate_date
HAVING COUNT(*) > 1;

--Shipment_id is not unique - might need to create composite key shipment_id + warehouse_block incase need to join
SELECT shipment_id, COUNT(*)
FROM shipments_stg
GROUP BY shipment_id
HAVING COUNT(*) > 1;