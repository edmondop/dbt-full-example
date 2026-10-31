select
    customer_id,
    count(*) as total_orders,
    sum(case when order_status = 'completed' then 1 else 0 end) as completed_orders
from {{ ref('stg__platform__orders') }}
group by customer_id
