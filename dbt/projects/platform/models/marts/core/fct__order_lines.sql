select
    order_item_id,
    order_id,
    cast(sku as varchar) as sku,
    category_id,
    quantity,
    line_amount_minor,
    currency_code
from {{ ref('int__orders__order_lines_with_products') }}
