select
    event_at,
    loaded_at,
    merchant_id,
    currency_code,
    gross_amount,
    refunded_amount,
    net_amount
from {{ ref('int__payments__payment_settlement_events') }}

union all

select
    event_at,
    loaded_at,
    merchant_id,
    currency_code,
    gross_amount,
    refunded_amount,
    net_amount
from {{ ref('int__payments__refund_settlement_events') }}
