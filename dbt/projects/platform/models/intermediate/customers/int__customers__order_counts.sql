select
    customer_id,
    count(*) as order_count,
    sum(is_completed_order) as completed_order_count
from {{ ref('int__customers__orders_with_completion_flag') }}
group by customer_id
