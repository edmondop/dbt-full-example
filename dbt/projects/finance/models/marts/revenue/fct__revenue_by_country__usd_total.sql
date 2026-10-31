{{ marketplace_macros.assert_reporting_currency('USD') }}
select
    m.country_code,
    cast(sum(r.order_amount_usd) as decimal(18, 4)) as revenue_usd
from {{ ref('int__revenue__orders_settled') }} as r
inner join {{ ref('stg__platform__merchants') }} as m on r.merchant_id = m.merchant_id
group by m.country_code
