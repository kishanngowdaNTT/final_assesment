
{% snapshot snap_customers %}

{{
    config(
        target_schema='dbt_dev',
        unique_key='customer_id',
        strategy='check',
        check_cols=[
            'customer_name',
            'customer_city',
            'customer_state',
            'customer_dob'
        ]
    )
}}

SELECT
    customer_id,
    customer_name,
    customer_city,
    customer_state,
    customer_dob

FROM {{ ref('int_customers') }}

{% endsnapshot %}
