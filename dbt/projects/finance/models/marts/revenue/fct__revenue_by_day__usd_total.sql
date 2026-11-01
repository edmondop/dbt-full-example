{{ marketplace_macros.assert_reporting_currency('USD') }}

select
    order_date,
    merchant_id,
    count(*) as completed_orders,
    cast(sum(order_amount_usd) as decimal(18, 4)) as revenue_usd
from {{ ref('int__revenue__orders_settled') }}
group by order_date, merchant_id
