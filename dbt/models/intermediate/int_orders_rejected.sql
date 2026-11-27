
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
FROM all_rejected_records
