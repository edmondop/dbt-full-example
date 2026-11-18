select
    sends.email_send_id,
    sends.customer_id,
    orders.order_id
from {{ ref('int__lifecycle__email_response_windows') }} as sends
left join {{ ref('int__purchases__completed_orders') }} as orders
    on
        sends.customer_id = orders.customer_id
        and orders.order_date between sends.sent_date and sends.response_window_end
