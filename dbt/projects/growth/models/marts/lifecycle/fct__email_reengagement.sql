select
    sends.email_send_id,
    sends.customer_id,
    count(orders.order_id) as completed_orders_within_window
from {{ ref('stg__marketing__email_sends') }} as sends
left join {{ ref('stg__platform__orders') }} as orders
    on
        sends.customer_id = orders.customer_id
        and orders.order_status = 'completed'
        and {{ dbt.datediff('cast(sends.sent_at as date)', 'orders.order_date', 'day') }}
        between 0 and {{ var('email_response_days') }}
group by sends.email_send_id, sends.customer_id
