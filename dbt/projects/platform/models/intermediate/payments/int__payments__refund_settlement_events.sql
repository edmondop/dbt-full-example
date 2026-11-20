select
    refunded_at as event_at,
    loaded_at,
    merchant_id,
    currency_code,
    cast(0 as decimal(18, 4)) as gross_amount,
    amount as refunded_amount,
    cast(-amount as decimal(18, 4)) as net_amount
from {{ ref('int__payments__refunds_with_orders') }}
