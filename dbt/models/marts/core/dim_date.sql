
{{ config(materialized='table') }}

WITH date_range AS (

    SELECT
        MIN(order_date) AS min_date,
        MAX(order_date) AS max_date
    FROM {{ ref('silver_orders') }}

),

generated_dates AS (

    SELECT
        EXPLODE(
            SEQUENCE(
                min_date,
                max_date,
                INTERVAL 1 DAY
            )
        ) AS full_date

    FROM date_range

)

SELECT
    CAST(DATE_FORMAT(full_date, 'yyyyMMdd') AS INT) AS date_key,

    full_date,

    YEAR(full_date) AS year,

    QUARTER(full_date) AS quarter,

    MONTH(full_date) AS month,

    DATE_FORMAT(full_date, 'MMMM') AS month_name,

    DATE_FORMAT(full_date, 'EEEE') AS day_name,

    CASE
        WHEN DAYOFWEEK(full_date) IN (1, 7)
            THEN TRUE
        ELSE FALSE
    END AS is_weekend

FROM generated_dates
