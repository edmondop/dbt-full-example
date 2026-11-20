{{ marketplace_macros.assert_reporting_currency('USD') }}

select
    payment_date,
    merchant_id,
    cast(currency_code as varchar) as currency_code,
    gross_amount,
    refunded_amount,
    net_amount,
    rate_to_reporting as fx_rate_to_usd,
    cast(gross_amount * rate_to_reporting as decimal(18, 4)) as gross_amount_usd,
    cast(refunded_amount * rate_to_reporting as decimal(18, 4)) as refunded_amount_usd,
    cast(net_amount * rate_to_reporting as decimal(18, 4)) as net_amount_usd
from {{ ref('int__payments__net_by_day_with_rates') }}
