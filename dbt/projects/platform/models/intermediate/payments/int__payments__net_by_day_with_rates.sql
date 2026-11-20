select
    net.payment_date,
    net.merchant_id,
    net.currency_code,
    net.gross_amount,
    net.refunded_amount,
    net.net_amount,
    fx.rate_to_reporting
from {{ ref('int__payments__net_by_day') }} as net
left join {{ ref('int__fx_rates__rates_by_day') }} as fx
    on
        net.payment_date = fx.rate_date
        and net.currency_code = fx.currency_code
