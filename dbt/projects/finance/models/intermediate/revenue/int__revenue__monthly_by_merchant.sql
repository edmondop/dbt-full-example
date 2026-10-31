select
    merchant_id,
    cast({{ dbt.date_trunc('month', 'order_date') }} as date) as revenue_month,
    count(*) as completed_orders,
    cast(sum(order_amount_usd) as decimal(18, 4)) as revenue_usd
from {{ ref('int__revenue__orders_settled') }}
group by merchant_id, cast({{ dbt.date_trunc('month', 'order_date') }} as date)
