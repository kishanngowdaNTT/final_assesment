
WITH source_data AS (
    SELECT *
    FROM {{ source('bronze', 'orders_raw') }}
    WHERE batch_id = '{{ var("batch_id") }}'
),

staged AS (

    SELECT
        TRIM(CAST(order_id AS STRING)) AS order_id,

        CAST(order_date AS DATE) AS order_date,

        TRIM(CAST(order_status AS STRING)) AS order_status,

        CAST(order_updated_at AS TIMESTAMP) AS order_updated_at,

        TRIM(CAST(customer_id AS STRING)) AS customer_id,
        TRIM(CAST(customer_name AS STRING)) AS customer_name,
        TRIM(CAST(customer_city AS STRING)) AS customer_city,
        TRIM(CAST(customer_state AS STRING)) AS customer_state,
        CAST(customer_dob AS DATE) AS customer_dob,

        TRIM(CAST(product_id AS STRING)) AS product_id,
        TRIM(CAST(product_name AS STRING)) AS product_name,
        TRIM(CAST(category AS STRING)) AS category,
        TRIM(CAST(brand AS STRING)) AS brand,

        CAST(quantity AS INT) AS quantity,
        CAST(unit_price AS DECIMAL(12,2)) AS unit_price,
        CAST(discount AS DECIMAL(12,2)) AS discount,

        TRIM(CAST(payment_method_id AS STRING)) AS payment_method_id,
        TRIM(CAST(payment_method AS STRING)) AS payment_method,
        TRIM(CAST(payment_provider AS STRING)) AS payment_provider,

        batch_id,
        source_file,
        CAST(ingestion_timestamp AS TIMESTAMP) AS ingestion_timestamp

    FROM source_data

)

SELECT *
FROM staged
