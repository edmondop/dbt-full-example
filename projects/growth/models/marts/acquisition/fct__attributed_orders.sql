select
    customer_id,
    campaign_id,
    channel,
    order_id,
    order_date,
    order_amount
from {{ ref('int__acquisition__attributed_orders') }}
