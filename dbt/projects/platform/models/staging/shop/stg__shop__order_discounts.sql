select
    id as order_discount_id,
    order_id,
    promotion_id,
    amount_minor
from {{ source('shop', 'order_discounts') }}
