WITH RAW_SOURCE AS (
    SELECT *
    FROM {{ ref('raw_customers') }}
),

TRANSFORMED AS (
    SELECT CAST(customer_id AS {{ type_string() }}) AS customer_id
        , LOWER(first_name) AS first_name
        , LOWER(last_name) AS last_name
    FROM RAW_SOURCE
)

SELECT *
FROM TRANSFORMED