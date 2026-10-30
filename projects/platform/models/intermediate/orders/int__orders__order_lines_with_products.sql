select
    items.order_item_id,
    items.order_id,
    items.sku,
    items.quantity,
    items.line_amount_minor,
    products.category_id,
    products.list_price_minor,
    orders.currency_code
from {{ ref('stg__shop__order_items') }} as items
inner join {{ ref('stg__shop__products') }} as products on items.sku = products.sku
inner join {{ ref('stg__shop__orders') }} as orders on items.order_id = orders.order_id
