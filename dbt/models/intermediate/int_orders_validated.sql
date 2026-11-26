
WITH source_data AS (

    SELECT *
    FROM {{ ref('stg_orders') }}

),

validation AS (

    SELECT
        *,

        CASE
            WHEN order_id IS NULL OR TRIM(order_id) = ''
                THEN 'MISSING_ORDER_ID'

            WHEN order_date IS NULL
                THEN 'MISSING_ORDER_DATE'

            WHEN order_status IS NULL OR TRIM(order_status) = ''
                THEN 'MISSING_ORDER_STATUS'

            WHEN customer_id IS NULL OR TRIM(customer_id) = ''
                THEN 'MISSING_CUSTOMER_ID'

            WHEN product_id IS NULL OR TRIM(product_id) = ''
                THEN 'MISSING_PRODUCT_ID'

            WHEN quantity IS NULL OR quantity <= 0
                THEN 'INVALID_QUANTITY'

            WHEN unit_price IS NULL OR unit_price < 0
                THEN 'INVALID_UNIT_PRICE'

            WHEN discount IS NULL OR discount < 0
                THEN 'INVALID_DISCOUNT'

            WHEN discount > (quantity * unit_price)
                THEN 'DISCOUNT_EXCEEDS_GROSS_AMOUNT'

            ELSE NULL
        END AS reject_reason

    FROM source_data

)

SELECT
    *,
    CASE
        WHEN reject_reason IS NULL THEN 'VALID'
        ELSE 'INVALID'
    END AS validation_status

FROM validation
