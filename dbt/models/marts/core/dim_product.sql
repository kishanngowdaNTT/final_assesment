{{ config(materialized='table') }}

WITH ranked_products AS (

    SELECT
        product_id,
        product_name,
        category,
        brand,

        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY product_name
        ) AS row_num

    FROM {{ ref('silver_orders') }}

    WHERE product_id IS NOT NULL

)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY product_id
    ) AS product_key,
    product_id,
    product_name,
    category,
    brand

FROM ranked_products
WHERE row_num = 1