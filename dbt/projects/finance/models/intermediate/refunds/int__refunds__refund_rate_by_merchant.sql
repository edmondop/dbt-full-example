select
    merchant_id,
    count(*) as completed_orders,
    count(refunded_order_id) as refunded_orders
from {{ ref('int__refunds__completed_orders_with_refunds') }}
group by merchant_id
