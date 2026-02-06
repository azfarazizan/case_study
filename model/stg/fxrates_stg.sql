CREATE TABLE fxrates_stg (
    rate_date DATE
    , base_currency TEXT
    , quote_currency TEXT
    , fx_to_usd NUMERIC(12,6)
);

INSERT INTO fxrates_stg(rate_date, base_currency, quote_currency, fx_to_usd)
SELECT
    rate_date::DATE AS rate_date                   
    , base_currency
    , quote_currency
    , REPLACE(fx_to_usd, ';', '.')::NUMERIC(12,6) AS fx_to_usd 
FROM fx_rates;