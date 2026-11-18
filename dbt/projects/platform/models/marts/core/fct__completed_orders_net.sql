select
    order_id,
    customer_id,
    merchant_id,
    currency_code,
    order_date,
    order_amount,
    coalesce(discount_amount_minor, 0) as discount_amount_minor,
    applied_discount_percent,
    cast(order_amount - {{ marketplace_macros.minor_units_to_major(
        'coalesce(discount_amount_minor, 0)', 'currency_code'
    ) }} as decimal(18, 4)) as net_order_amount
from {{ ref('int__orders__completed_with_discounts') }}
