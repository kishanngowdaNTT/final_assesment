

{{ config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key='order_id',
    schema='silver',
    alias='orders_clean' if target.schema != 'dbt_dev' else 'silver_orders'
) }}


WITH deduplicated_orders AS (
    SELECT *
    FROM {{ ref('int_orders_deduplicated') }}
),

standardized AS (
    SELECT
        order_id,
        order_date,
        UPPER(TRIM(order_status)) AS order_status,
        order_updated_at,
        customer_id,
        INITCAP(TRIM(customer_name)) AS customer_name,
        INITCAP(TRIM(customer_city)) AS customer_city,
        UPPER(TRIM(customer_state)) AS customer_state,
        customer_dob,
        product_id,
        INITCAP(TRIM(product_name)) AS product_name,
        INITCAP(TRIM(category)) AS category,
        TRIM(brand) AS brand,
        quantity,
        unit_price,
        discount,
        payment_method_id,
        UPPER(TRIM(payment_method)) AS payment_method,
        TRIM(payment_provider) AS payment_provider,
        batch_id,
        source_file,
        ingestion_timestamp
    FROM deduplicated_orders
)

SELECT incoming.*
FROM standardized incoming

{% if is_incremental() %}

WHERE NOT EXISTS (
    SELECT 1
    FROM {{ this }} existing
    WHERE existing.order_id = incoming.order_id
      AND COALESCE(
            incoming.order_updated_at,
            CAST('1900-01-01' AS TIMESTAMP)
          )
          <= COALESCE(
            existing.order_updated_at,
            CAST('1900-01-01' AS TIMESTAMP)
          )
)

{% endif %}