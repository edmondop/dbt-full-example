select
    email_send_id,
    customer_id,
    count(order_id) as completed_orders_within_window
from {{ ref('int__lifecycle__email_send_orders') }}
group by email_send_id, customer_id
