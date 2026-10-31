select
    order_id,
    count(*) as refund_count,
    cast(sum(amount) as decimal(18, 4)) as refunded_amount
from {{ ref('int__refunds__refunds_with_orders') }}
group by order_id
