select
    created_at as event_at,
    loaded_at,
    merchant_id,
    currency_code,
    amount as gross_amount,
    cast(0 as decimal(18, 4)) as refunded_amount,
    amount as net_amount
from {{ ref('int__payments__attempts_with_merchant') }}
where payment_status = 'succeeded'
