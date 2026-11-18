select
    customer_id,
    first_order_date,
    min(order_date) as second_order_date
from {{ ref('int__retention__orders_after_first') }}
group by customer_id, first_order_date
