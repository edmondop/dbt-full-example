select
    orders.order_id,
    orders.customer_id,
    orders.merchant_id,
    orders.order_date,
    orders.currency_code,
    orders.order_amount,
    coalesce(discounts.discount_amount_minor, 0) as discount_amount_minor,
    promotions.discount_percent as applied_discount_percent,
    cast(orders.order_amount - {{ marketplace_macros.minor_units_to_major(
        'coalesce(discounts.discount_amount_minor, 0)', 'orders.currency_code'
    ) }} as decimal(18, 4)) as net_order_amount
from {{ ref('int__orders__completed') }} as orders
left join {{ ref('int__orders__discounts_by_order') }} as discounts on orders.order_id = discounts.order_id
left join {{ ref('stg__shop__promotions') }} as promotions on discounts.promotion_id = promotions.promotion_id
