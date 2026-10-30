select
    payment_date,
    merchant_id,
    currency_code,
    gross_amount,
    refunded_amount,
    net_amount,
    fx_rate_to_usd,
    gross_amount_usd,
    refunded_amount_usd,
    net_amount_usd
from {{ ref('platform', 'fct__payments_by_day__usd_total') }}
