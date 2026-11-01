{{ marketplace_macros.assert_reporting_currency('USD') }}

select
    cast({{ dbt.date_trunc('month', 'payment_date') }} as date) as refund_month,
    merchant_id,
    cast(sum(refunded_amount_usd) as decimal(18, 4)) as refunded_amount_usd,
    cast(sum(gross_amount_usd) as decimal(18, 4)) as gross_amount_usd
from {{ ref('stg__platform__payments_by_day__usd_total') }}
group by 1, 2
