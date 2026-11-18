{#- FX comes from v1 of platform's fct__fx_rates_by_day (see stg__platform__fx_rates_by_day). -#}
select
    orders.order_id,
    orders.merchant_id,
    orders.order_date,
    orders.currency_code,
    orders.order_amount,
    fx.rate_to_usd
from {{ ref('int__revenue__completed_orders') }} as orders
left join {{ ref('stg__platform__fx_rates_by_day') }} as fx
    on
        orders.order_date = fx.rate_date
        and orders.currency_code = fx.currency_code
