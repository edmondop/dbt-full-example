select
    id as payment_id,
    cast(metadata_order_id as bigint) as order_id,
    upper(currency) as currency_code,
    amount as amount_minor,
    {{ marketplace_macros.minor_units_to_major('amount', 'currency') }} as amount,
    status as payment_status,
    {{ marketplace_macros.epoch_seconds_to_timestamp('created') }} as created_at,
    _loaded_at as loaded_at
from {{ source('psp', 'payments') }}
