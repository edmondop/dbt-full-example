select
    orders.order_id,
    orders.merchant_id,
    refunds.order_id as refunded_order_id
from {{ ref('int__revenue__completed_orders') }} as orders
left join {{ ref('int__refunds__refunds_by_order') }} as refunds
    on orders.order_id = refunds.order_id
