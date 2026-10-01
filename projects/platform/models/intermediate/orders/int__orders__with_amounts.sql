with order_totals as (
    select
        order_id,
        sum(line_amount_minor) as order_amount_minor
    from {{ ref('stg__shop__order_items') }}
    group by order_id
)

select
    orders.order_id,
    orders.customer_id,
    orders.merchant_id,
    orders.currency_code,
    orders.order_status,
    orders.ordered_at,
    {{ marketplace_macros.local_day_in_business_tz('orders.ordered_at') }} as order_date,
    coalesce(order_totals.order_amount_minor, 0) as order_amount_minor,
    {{ marketplace_macros.minor_units_to_major(
        'coalesce(order_totals.order_amount_minor, 0)', 'orders.currency_code'
    ) }} as order_amount
from {{ ref('stg__shop__orders') }} as orders
left join order_totals
    on orders.order_id = order_totals.order_id
