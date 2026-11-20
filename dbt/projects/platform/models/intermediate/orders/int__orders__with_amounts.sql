select
    order_id,
    customer_id,
    merchant_id,
    currency_code,
    order_status,
    ordered_at,
    {{ marketplace_macros.local_day_in_business_tz('ordered_at') }} as order_date,
    coalesce(order_amount_minor, 0) as order_amount_minor,
    {{ marketplace_macros.minor_units_to_major('coalesce(order_amount_minor, 0)', 'currency_code') }} as order_amount
from {{ ref('int__orders__orders_with_item_totals') }}
