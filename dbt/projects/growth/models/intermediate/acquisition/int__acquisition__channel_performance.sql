select
    channel,
    count(distinct customer_id) as attributed_customers,
    count(distinct order_id) as attributed_orders
from {{ ref('int__acquisition__attributed_orders') }}
group by channel
