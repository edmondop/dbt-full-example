{{ marketplace_macros.assert_reporting_currency('USD') }}

select
    net.payment_date,
    net.merchant_id,
    cast(net.currency_code as varchar) as currency_code,
    net.gross_amount,
    net.refunded_amount,
    net.net_amount,
    fx.rate_to_reporting as fx_rate_to_usd,
    cast(net.gross_amount * fx.rate_to_reporting as decimal(18, 4)) as gross_amount_usd,
    cast(net.refunded_amount * fx.rate_to_reporting as decimal(18, 4)) as refunded_amount_usd,
    cast(net.net_amount * fx.rate_to_reporting as decimal(18, 4)) as net_amount_usd
from {{ ref('int__payments__net_by_day') }} as net
left join {{ ref('int__fx__rates_by_day') }} as fx
    on
        net.payment_date = fx.rate_date
        and net.currency_code = fx.currency_code
