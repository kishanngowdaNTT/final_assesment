
{{ config(materialized='ephemeral') }}

WITH valid_records AS (

    SELECT *
    FROM {{ ref('int_orders_validated') }}
    WHERE validation_status = 'VALID'

),

status_priority AS (

    SELECT
        *,

        CASE
            WHEN UPPER(TRIM(order_status)) = 'CANCELLED' THEN 1
            WHEN UPPER(TRIM(order_status)) = 'DELIVERED' THEN 2
            WHEN UPPER(TRIM(order_status)) = 'SHIPPED' THEN 3
            WHEN UPPER(TRIM(order_status)) = 'PROCESSING' THEN 4
            ELSE 5
        END AS status_priority

    FROM valid_records

),

ranked_records AS (

    SELECT
        *,

        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY
    COALESCE(
        order_updated_at,
        CAST('1900-01-01' AS TIMESTAMP)
    ) DESC,
    status_priority ASC,
    ingestion_timestamp DESC
        ) AS row_num

    FROM status_priority

)

SELECT *
FROM ranked_records
