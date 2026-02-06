CREATE TABLE shipments_stg (
  shipment_id INT
  , warehouse_block CHAR(1)
  , mode_of_shipment TEXT
  , customer_care_calls INT
  , customer_rating INT
  , order_amount_local DECIMAL(12,2)
  , currency_code CHAR(3)
  , prior_purchases INT
  , product_importance TEXT
  , discount_offered INT
  , weight_in_gms INT
  , reached_on_time_y_n INT
  , customer_id TEXT
  , shipment_date DATE
)

INSERT INTO shipments_stg (
    shipment_id
    , warehouse_block
    , mode_of_shipment
    , customer_care_calls
    , customer_rating
    , order_amount_local
    , currency_code
    , prior_purchases
    , product_importance
    , discount_offered
    , weight_in_gms
    , reached_on_time_y_n
    , customer_id
    , shipment_date
)
SELECT
    shipment_id::INT
    , warehouse_block
    , mode_of_shipment
    , customer_care_calls::INT
    , customer_rating::INT
    , REPLACE(order_amount_local, 'O', '0')::NUMERIC
    , currency_code
    , prior_purchases::INT
    , product_importance
    , discount_offered::INT
    , weight_in_gms::INT
    , reached_on_time_y_n ::INT
    , customer_id,
    , TO_DATE(shipment_date, 'DD.MM.YYYY')
FROM shipments