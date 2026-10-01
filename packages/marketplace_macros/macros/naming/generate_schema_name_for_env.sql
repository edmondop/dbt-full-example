{#-
  Schema naming shared by every project. Each project's own
  `generate_schema_name` delegates here (dbt only calls the root project's).

  - prod targets (name starts with `prod`): the custom schema as configured,
    e.g. `staging`, `fx`, so consumers get stable names.
  - any other target: `<dev_schema_prefix>_<custom schema>`, so developers
    and CI runs never collide. `dev_schema_prefix` defaults to $USER.
-#}
{% macro generate_schema_name_for_env(custom_schema_name, node) -%}
  {%- set base = (custom_schema_name or target.schema) | trim -%}
  {%- if target.name.startswith('prod') -%}
    {{ base }}
  {%- else -%}
    {{ var('dev_schema_prefix') | trim }}_{{ base }}
  {%- endif -%}
{%- endmacro %}
