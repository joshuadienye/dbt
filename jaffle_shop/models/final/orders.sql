{% set payment_methods = ['credit_card', 'coupon', 'bank_transfer', 'gift_card'] %}

WITH ORDERS AS (
    SELECT *
    FROM {{ ref('base_orders') }}
),

PAYMENTS AS (
    SELECT *
    FROM {{ ref('base_payments') }}
),

ORDER_PAYMENTS AS (
    SELECT order_id
        {% for payment_method in payment_methods -%}
        , SUM(case when payment_method = '{{ payment_method }}' then amount else 0 end) AS {{ payment_method }}_amount
        {% endfor -%}
        , SUM(amount) AS total_amount
    FROM PAYMENTS
    GROUP BY order_id
),

FINAL AS (
    SELECT ORDERS.order_id
        , ORDERS.customer_id
        , ORDERS.order_date
        , ORDERS.status

        {% for payment_method in payment_methods -%}
        , COALESCE(ORDER_PAYMENTS.{{ payment_method }}_amount, 0) AS {{ payment_method }}_amount
        {% endfor -%}

        , COALESCE(ORDER_PAYMENTS.total_amount, 0) AS amount
    FROM ORDERS

    LEFT JOIN ORDER_PAYMENTS
    ON ORDERS.order_id = ORDER_PAYMENTS.order_id
)

SELECT *
FROM FINAL