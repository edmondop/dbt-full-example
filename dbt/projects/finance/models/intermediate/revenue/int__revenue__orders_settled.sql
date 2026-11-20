{#- Completed orders valued in USD at the order day's rate. -#}
{{ marketplace_macros.assert_reporting_currency('USD') }}

select
    order_id,
    merchant_id,
    order_date,
    currency_code,
    order_amount,
    rate_to_usd,
    cast(order_amount * rate_to_usd as decimal(18, 4)) as order_amount_usd
from {{ ref('int__revenue__completed_orders_with_rates') }}
