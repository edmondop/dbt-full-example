select
    customer_id,
    min(order_date) as first_order_date
from {{ ref('int__orders__completed') }}
group by customer_id
