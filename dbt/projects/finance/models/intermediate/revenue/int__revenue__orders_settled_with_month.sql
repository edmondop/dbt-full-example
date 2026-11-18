select
    order_id,
    merchant_id,
    cast({{ dbt.date_trunc('month', 'order_date') }} as date) as revenue_month,
    order_amount_usd
from {{ ref('int__revenue__orders_settled') }}
