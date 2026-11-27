{{ config(materialized='table') }}

SELECT
    c.customer_city,
    COUNT(f.order_id) AS total_orders,
    SUM(f.quantity) AS total_quantity,
    SUM(f.gross_amount) AS total_gross_sales,
    SUM(f.discount) AS total_discount,
    SUM(f.net_amount) AS total_net_sales

FROM {{ ref('fct_orders') }} f

LEFT JOIN {{ ref('dim_customer') }} c
    ON f.customer_key = c.customer_key

GROUP BY
    c.customer_city