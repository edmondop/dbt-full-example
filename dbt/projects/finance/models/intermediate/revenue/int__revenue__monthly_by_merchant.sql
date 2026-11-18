select
    merchant_id,
    revenue_month,
    count(*) as completed_orders,
    cast(sum(order_amount_usd) as decimal(18, 4)) as revenue_usd
from {{ ref('int__revenue__orders_settled_with_month') }}
group by merchant_id, revenue_month
