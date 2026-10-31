select
    order_id,
    count(*) as discount_count,
    max(promotion_id) as promotion_id,
    sum(amount_minor) as discount_amount_minor
from {{ ref('stg__shop__order_discounts') }}
group by order_id
