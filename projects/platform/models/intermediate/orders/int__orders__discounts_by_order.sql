select
    order_id,
    count(*) as discount_count,
    sum(amount_minor) as discount_amount_minor
from {{ ref('stg__shop__order_discounts') }}
group by order_id
