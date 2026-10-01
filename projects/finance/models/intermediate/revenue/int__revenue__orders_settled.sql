{#-
  Completed orders valued in USD at the order day's rate. FX comes from v1 of
  platform's fct__fx_rates_by_day (see stg__platform__fx_rates_by_day).
-#}
{{ marketplace_macros.assert_reporting_currency('USD') }}

select
    orders.order_id,
    orders.merchant_id,
    orders.order_date,
    orders.currency_code,
    orders.order_amount,
    fx.rate_to_usd,
    cast(orders.order_amount * fx.rate_to_usd as decimal(18, 4)) as order_amount_usd
from {{ ref('stg__platform__orders') }} as orders
left join {{ ref('stg__platform__fx_rates_by_day') }} as fx
    on
        orders.order_date = fx.rate_date
        and orders.currency_code = fx.currency_code
where orders.order_status = 'completed'
