select * from {{ ref('platform', 'fct__order_lines') }}
