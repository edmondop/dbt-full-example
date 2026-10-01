select
    id as refund_id,
    payment_id,
    upper(currency) as currency_code,
    amount as amount_minor,
    {{ marketplace_macros.minor_units_to_major('amount', 'currency') }} as amount,
    reason as refund_reason,
    status as refund_status,
    {{ marketplace_macros.epoch_seconds_to_timestamp('created') }} as refunded_at,
    _loaded_at as loaded_at
from {{ source('psp', 'refunds') }}
