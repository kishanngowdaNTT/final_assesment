
{{ config(materialized='table') }}

SELECT
    ROW_NUMBER() OVER (
        ORDER BY customer_id, dbt_valid_from
    ) AS customer_key,

    customer_id,
    customer_name,
    customer_city,
    customer_state,
    customer_dob,

    dbt_valid_from AS effective_start_date,
    dbt_valid_to AS effective_end_date,

    CASE
        WHEN dbt_valid_to IS NULL THEN TRUE
        ELSE FALSE
    END AS is_current

FROM {{ ref('snap_customers') }}
