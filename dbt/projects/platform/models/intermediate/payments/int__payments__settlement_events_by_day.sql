select
    {{ marketplace_macros.local_day_in_business_tz('event_at') }} as payment_date,
    merchant_id,
    currency_code,
    gross_amount,
    refunded_amount,
    net_amount,
    loaded_at
from {{ ref('int__payments__settlement_events') }}
