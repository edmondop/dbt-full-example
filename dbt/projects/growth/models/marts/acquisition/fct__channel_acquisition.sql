select
    channel,
    attributed_customers,
    attributed_orders
from {{ ref('int__acquisition__channel_performance') }}
