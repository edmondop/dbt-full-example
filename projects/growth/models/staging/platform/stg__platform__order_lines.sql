select
    order_item_id,
    order_id,
    sku,
    category_id,
    quantity,
    line_amount_minor,
    currency_code
from {{ ref('platform', 'fct__order_lines') }}
