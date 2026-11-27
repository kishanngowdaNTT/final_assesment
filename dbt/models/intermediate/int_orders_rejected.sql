
{{
    config(
        materialized='incremental',
        incremental_strategy='append',
        schema='bronze',
        alias='orders_rejected'
    )
}}

WITH invalid_records AS (

    SELECT
        order_id,
        order_date,
        order_status,
        order_updated_at,
        customer_id,
        customer_name,
        customer_city,
        customer_state,
        customer_dob,
        product_id,
        product_name,
        category,
        brand,
        quantity,
        unit_price,
        discount,
        payment_method_id,
        payment_method,
        payment_provider,
        batch_id,
        source_file,
        ingestion_timestamp,
        reject_reason

    FROM {{ ref('int_orders_validated') }}
    WHERE validation_status = 'INVALID'

),

duplicate_records AS (

    SELECT
        order_id,
        order_date,
        order_status,
        order_updated_at,
        customer_id,
        customer_name,
        customer_city,
        customer_state,
        customer_dob,
        product_id,
        product_name,
        category,
        brand,
        quantity,
        unit_price,
        discount,
        payment_method_id,
        payment_method,
        payment_provider,
        batch_id,
        source_file,
        ingestion_timestamp,
        'REJECTED_DUE_TO_DUPLICATE' AS reject_reason

    FROM {{ ref('int_orders_ranked') }}
    WHERE row_num > 1

),

all_rejected_records AS (

    SELECT * FROM invalid_records

    UNION ALL

    SELECT * FROM duplicate_records

)

SELECT *
FROM all_rejected_records r

{% if is_incremental() %}

WHERE NOT EXISTS (

    SELECT 1
    FROM {{ this }} existing

    WHERE
        existing.order_id <=> r.order_id
        AND existing.order_date <=> r.order_date
        AND existing.order_status <=> r.order_status
        AND existing.order_updated_at <=> r.order_updated_at
        AND existing.customer_id <=> r.customer_id
        AND existing.customer_name <=> r.customer_name
        AND existing.customer_city <=> r.customer_city
        AND existing.customer_state <=> r.customer_state
        AND existing.customer_dob <=> r.customer_dob
        AND existing.product_id <=> r.product_id
        AND existing.product_name <=> r.product_name
        AND existing.category <=> r.category
        AND existing.brand <=> r.brand
        AND existing.quantity <=> r.quantity
        AND existing.unit_price <=> r.unit_price
        AND existing.discount <=> r.discount
        AND existing.payment_method_id <=> r.payment_method_id
        AND existing.payment_method <=> r.payment_method
        AND existing.payment_provider <=> r.payment_provider
        AND existing.batch_id <=> r.batch_id
        AND existing.source_file <=> r.source_file
        AND existing.ingestion_timestamp <=> r.ingestion_timestamp
        AND existing.reject_reason <=> r.reject_reason

)

{% endif %}
