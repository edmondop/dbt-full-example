{% macro generate_schema_name(custom_schema_name, node) -%}
  {{ marketplace_macros.generate_schema_name_for_env(custom_schema_name, node) }}
{%- endmacro %}
