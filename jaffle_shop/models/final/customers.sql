WITH CUSTOMERS AS (
    SELECT *
    FROM {{ ref('base_customers') }}
),

ORDERS AS (
    SELECT *
    FROM {{ ref('base_orders') }}
),

PAYMENTS AS (
    SELECT *
    FROM {{ ref('base_payments') }}
),

CUSTOMER_ORDERS AS (
    SELECT customer_id
        , MIN(order_date) AS first_order
        , MAX(order_date) AS most_recent_order
        , COUNT(order_id) AS number_of_orders
    FROM ORDERS
    GROUP BY customer_id
),

CUSTOMER_PAYMENTS AS (
    SELECT ORDERS.customer_id
        , SUM(PAYMENTS.amount) AS total_amount
    FROM PAYMENTS

    LEFT JOIN ORDERS
    ON PAYMENTS.order_id = ORDERS.order_id

    GROUP BY ORDERS.customer_id
),

FINAL AS (
    SELECT CUSTOMERS.customer_id
        , CUSTOMERS.first_name
        , CUSTOMERS.last_name
        , CUSTOMER_ORDERS.first_order
        , CUSTOMER_ORDERS.most_recent_order
        , CUSTOMER_ORDERS.number_of_orders
        , CUSTOMER_PAYMENTS.total_amount AS customer_lifetime_value
    FROM CUSTOMERS

    LEFT JOIN CUSTOMER_ORDERS
    ON CUSTOMERS.customer_id = CUSTOMER_ORDERS.customer_id

    LEFT JOIN CUSTOMER_PAYMENTS
    ON  CUSTOMERS.customer_id = CUSTOMER_PAYMENTS.customer_id
)

SELECT *
FROM FINAL