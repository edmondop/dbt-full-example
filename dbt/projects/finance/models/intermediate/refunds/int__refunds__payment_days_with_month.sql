select
    payment_date,
    merchant_id,
    currency_code,
    cast({{ dbt.date_trunc('month', 'payment_date') }} as date) as refund_month,
    refunded_amount_usd,
    gross_amount_usd
from {{ ref('stg__platform__payments_by_day__usd_total') }}
