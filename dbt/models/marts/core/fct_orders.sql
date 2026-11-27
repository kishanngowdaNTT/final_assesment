

{{ config(
    materialized='table',
    schema='gold',
    alias='fact_orders' if target.schema != 'dbt_dev' else 'fct_orders'
) }}

SELECT
    s.order_id,

    d.date_key,
    c.customer_key,
    p.product_key,
    pm.payment_key,

    s.quantity,
    s.unit_price,
    s.discount,

    (s.quantity * s.unit_price) AS gross_amount,

    (s.quantity * s.unit_price) - s.discount AS net_amount,

    s.order_status,

    s.batch_id,
    s.source_file,
    s.ingestion_timestamp

FROM {{ ref('silver_orders') }} s

LEFT JOIN {{ ref('dim_date') }} d
    ON s.order_date = d.full_date

LEFT JOIN {{ ref('dim_customer') }} c
    ON s.customer_id = c.customer_id
    AND c.is_current = TRUE

LEFT JOIN {{ ref('dim_product') }} p
    ON s.product_id = p.product_id

LEFT JOIN {{ ref('dim_payment') }} pm
    ON s.payment_method_id = pm.payment_method_id
