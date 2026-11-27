
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- if target.name == 'prod' -%}

        {{ custom_schema_name | trim if custom_schema_name is not none else target.schema }}

    {%- else -%}

        {{ target.schema }}

    {%- endif -%}

{%- endmacro %}
