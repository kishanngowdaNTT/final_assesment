{{ config(materialized='table') }}

SELECT
    d.year,
    d.month,
    d.month_name,

    COUNT(f.order_id) AS total_orders,
    SUM(f.quantity) AS total_quantity,
    SUM(f.gross_amount) AS total_gross_sales,
    SUM(f.discount) AS total_discount,
    SUM(f.net_amount) AS total_net_sales

FROM {{ ref('fct_orders') }} f

LEFT JOIN {{ ref('dim_date') }} d
    ON f.date_key = d.date_key

GROUP BY
    d.year,
    d.month,
    d.month_name