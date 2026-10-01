select * from {{ ref('platform', 'fct__payments_by_day__usd_total') }}
