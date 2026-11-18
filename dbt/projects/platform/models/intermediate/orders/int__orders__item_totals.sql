select
    order_id,
    sum(line_amount_minor) as order_amount_minor
from {{ ref('stg__shop__order_items') }}
group by order_id
