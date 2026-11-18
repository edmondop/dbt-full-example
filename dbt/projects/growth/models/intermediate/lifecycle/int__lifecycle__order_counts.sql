select
    customer_id,
    count(*) as total_orders,
    sum(completed_order) as completed_orders
from {{ ref('int__purchases__completion_flags') }}
group by customer_id
