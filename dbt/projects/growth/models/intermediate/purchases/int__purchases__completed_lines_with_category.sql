select
    products.category_id,
    products.category_name,
    orders.currency_code,
    order_lines.quantity,
    order_lines.line_amount_minor
from {{ ref('stg__platform__order_lines') }} as order_lines
inner join {{ ref('stg__platform__products') }} as products on order_lines.sku = products.sku
inner join {{ ref('int__purchases__completed_orders') }} as orders on order_lines.order_id = orders.order_id
