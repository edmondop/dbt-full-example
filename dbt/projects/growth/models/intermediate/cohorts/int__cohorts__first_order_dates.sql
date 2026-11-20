select
    customer_id,
    min(order_date) as first_order_date
from {{ ref('int__purchases__completed_orders') }}
group by customer_id
