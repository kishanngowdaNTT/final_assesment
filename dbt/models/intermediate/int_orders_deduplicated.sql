
WITH deduplicated_orders AS (

    SELECT *
    FROM {{ ref('int_orders_ranked') }}
    WHERE row_num = 1

)

SELECT
    * EXCEPT (
        status_priority,
        row_num,
        reject_reason,
        validation_status
    )

FROM deduplicated_orders
