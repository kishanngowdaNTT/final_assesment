{{ config(materialized='table') }}

WITH ranked_payments AS (

    SELECT
        payment_method_id,
        payment_method,
        payment_provider,

        ROW_NUMBER() OVER (
            PARTITION BY payment_method_id
            ORDER BY payment_method
        ) AS row_num

    FROM {{ ref('silver_orders') }}

    WHERE payment_method_id IS NOT NULL

)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY payment_method_id
    ) AS payment_key,
    payment_method_id,
    payment_method,
    payment_provider

FROM ranked_payments
WHERE row_num = 1