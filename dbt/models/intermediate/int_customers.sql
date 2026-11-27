
WITH customer_records AS (

    SELECT
        customer_id,
        customer_name,
        customer_city,
        customer_state,
        customer_dob,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY
                order_updated_at DESC,
                ingestion_timestamp DESC,
                order_id DESC
        ) AS row_num

    FROM {{ ref('silver_orders') }}

    WHERE customer_id IS NOT NULL

)

SELECT
    customer_id,
    customer_name,
    customer_city,
    customer_state,
    customer_dob

FROM customer_records

WHERE row_num = 1
