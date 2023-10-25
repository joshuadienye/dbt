WITH RAW_SOURCE AS (
    SELECT *
    FROM {{ ref('raw_payments') }}
),

TRANSFORMED AS (
    SELECT CAST(payment_id AS {{ type_string() }}) AS payment_id
        , CAST(order_id AS {{ type_string() }}) AS order_id
        , LOWER(payment_method) AS payment_method
        , CAST(amount AS {{ type_float() }}) AS amount
    FROM RAW_SOURCE
)

SELECT *
FROM TRANSFORMED