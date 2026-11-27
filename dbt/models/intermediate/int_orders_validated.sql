
WITH source_data AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

validation AS (

    SELECT
        *,

        CONCAT_WS(
            ', ',

            CASE
                WHEN order_id IS NULL OR TRIM(order_id) = ''
                THEN 'Missing order_id'
            END,

            CASE
                WHEN order_date IS NULL
                THEN 'Missing order_date'
            END,

            CASE
                WHEN customer_id IS NULL OR TRIM(customer_id) = ''
                THEN 'Missing customer_id'
            END,

            CASE
                WHEN product_id IS NULL OR TRIM(product_id) = ''
                THEN 'Missing product_id'
            END,

            CASE
                WHEN quantity IS NULL OR quantity <= 0
                THEN 'Invalid quantity'
            END,

            CASE
                WHEN unit_price IS NULL OR unit_price < 0
                THEN 'Invalid unit_price'
            END,

            CASE
                WHEN discount IS NULL OR discount < 0
                THEN 'Invalid discount'
            END,

            CASE
                WHEN quantity * unit_price < discount
                THEN 'Discount exceeds gross amount'
            END

        ) AS reject_reason

    FROM source_data

)

SELECT
    *,

    CASE
        WHEN reject_reason = '' THEN 'VALID'
        ELSE 'INVALID'
    END AS validation_status

FROM validation
