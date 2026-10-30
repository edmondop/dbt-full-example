select
    customer_id,
    count(*) as order_count,
    sum(case when order_status = 'completed' then 1 else 0 end) as completed_order_count
from {{ ref('int__orders__with_amounts') }}
group by customer_id
