select
    merchant_id,
    completed_orders,
    refunded_orders,
    cast(refunded_orders as decimal(18, 4)) / nullif(completed_orders, 0) as refund_rate
from {{ ref('int__refunds__refund_rate_by_merchant') }}
