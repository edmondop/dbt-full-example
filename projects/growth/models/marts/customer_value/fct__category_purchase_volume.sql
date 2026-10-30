select
    products.category_id,
    products.category_name,
    orders.currency_code,
    sum(order_lines.quantity) as units_sold,
    sum(order_lines.line_amount_minor) as gross_amount_minor
from {{ ref('stg__platform__order_lines') }} as order_lines
inner join {{ ref('stg__platform__products') }} as products on order_lines.sku = products.sku
inner join {{ ref('stg__platform__orders') }} as orders on order_lines.order_id = orders.order_id
where orders.order_status = 'completed'
group by products.category_id, products.category_name, orders.currency_code
