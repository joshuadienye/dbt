WITH RAW_SOURCE AS (
    SELECT *
    FROM {{ ref('raw_orders') }}
),

TRANSFORMED AS (
    SELECT CAST(order_id AS {{ type_string() }}) AS order_id
        , CAST(customer_id AS {{ type_string() }}) AS customer_id
        , CAST(order_date AS DATE) AS order_date
        , LOWER(status) AS status
    FROM RAW_SOURCE
)

SELECT *
FROM TRANSFORMED