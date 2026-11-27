{{ config(materialized='table') }}

SELECT
    p.category,

    COUNT(f.order_id) AS total_orders,
    SUM(f.quantity) AS total_quantity,
    SUM(f.gross_amount) AS total_gross_sales,
    SUM(f.discount) AS total_discount,
    SUM(f.net_amount) AS total_net_sales

FROM {{ ref('fct_orders') }} f

LEFT JOIN {{ ref('dim_product') }} p
    ON f.product_key = p.product_key

GROUP BY
    p.category