select
    refund_id,
    payment_id,
    currency_code,
    amount,
    refunded_at,
    loaded_at
from {{ ref('stg__psp__refunds') }}
where refund_status = 'succeeded'
