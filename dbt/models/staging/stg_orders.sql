
WITH source_data AS (

    SELECT *
    FROM {{ source('bronze', 'orders_raw') }}

),

standardized AS (

    SELECT
        TRIM(CAST(order_id AS STRING)) AS order_id,

        CAST(order_date AS DATE) AS order_date,

        INITCAP(TRIM(order_status)) AS order_status,

        CAST(order_updated_at AS TIMESTAMP) AS order_updated_at,

        TRIM(CAST(customer_id AS STRING)) AS customer_id,
        INITCAP(TRIM(customer_name)) AS customer_name,
        INITCAP(TRIM(customer_city)) AS customer_city,
        INITCAP(TRIM(customer_state)) AS customer_state,
        CAST(customer_dob AS DATE) AS customer_dob,

        TRIM(CAST(product_id AS STRING)) AS product_id,
        INITCAP(TRIM(product_name)) AS product_name,
        INITCAP(TRIM(category)) AS category,
        TRIM(brand) AS brand,

        CAST(quantity AS INT) AS quantity,
        CAST(unit_price AS DECIMAL(12,2)) AS unit_price,
        CAST(discount AS DECIMAL(12,2)) AS discount,

        TRIM(CAST(payment_method_id AS STRING)) AS payment_method_id,
        INITCAP(TRIM(payment_method)) AS payment_method,
        TRIM(payment_provider) AS payment_provider,

        batch_id,
        source_file,
        CAST(ingestion_timestamp AS TIMESTAMP) AS ingestion_timestamp

    FROM source_data

)

SELECT *
FROM standardized
