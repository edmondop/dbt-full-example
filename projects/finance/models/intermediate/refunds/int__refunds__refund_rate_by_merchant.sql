select
    o.merchant_id,
    count(*) as completed_orders,
    sum(case when r.order_id is not null then 1 else 0 end) as refunded_orders
from {{ ref('stg__platform__orders') }} as o
left join {{ ref('int__refunds__refunds_by_order') }} as r on o.order_id = r.order_id
where o.order_status = 'completed'
group by o.merchant_id
