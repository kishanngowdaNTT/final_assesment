{{ config(materialized='table') }}

SELECT
    p.payment_method,
    p.payment_provider,

    COUNT(f.order_id) AS total_orders,
    SUM(f.gross_amount) AS total_gross_sales,
    SUM(f.discount) AS total_discount,
    SUM(f.net_amount) AS total_net_sales

FROM {{ ref('fct_orders') }} f

LEFT JOIN {{ ref('dim_payment') }} p
    ON f.payment_key = p.payment_key

GROUP BY
    p.payment_method,
    p.payment_provider