
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
                order_updated_at DESC,
                status_priority ASC
        ) AS row_num

    FROM status_priority

)

SELECT *
FROM ranked_records
