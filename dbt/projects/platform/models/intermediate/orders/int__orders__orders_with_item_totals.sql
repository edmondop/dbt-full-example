select
    orders.order_id,
    orders.customer_id,
    orders.merchant_id,
    orders.currency_code,
    orders.order_status,
    orders.ordered_at,
    order_totals.order_amount_minor
from {{ ref('stg__shop__orders') }} as orders
left join {{ ref('int__orders__item_totals') }} as order_totals
    on orders.order_id = order_totals.order_id
