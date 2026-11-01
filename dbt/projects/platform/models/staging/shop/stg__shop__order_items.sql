select
    id as order_item_id,
    order_id,
    sku,
    quantity,
    unit_price_minor,
    quantity * unit_price_minor as line_amount_minor
from {{ source('shop', 'order_items') }}
