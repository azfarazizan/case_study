CREATE TABLE customer_stg (
    customer_id TEXT
    , customer_name TEXT
    , customer_segment TEXT
    , account_tier TEXT
    , country_code TEXT
    , region TEXT
    , currency_code TEXT
);

INSERT INTO customer_stg
SELECT
    customer_id TEXT
    , customer_name TEXT
    , customer_segment TEXT
    , account_tier TEXT
    , country_code TEXT
    , region TEXT
    , currency_code TEXT
FROM customer;
