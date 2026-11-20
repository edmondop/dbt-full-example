select
    report_date,
    merchant_id,
    cast(sum(revenue_usd) as decimal(18, 4)) as revenue_usd,
    cast(sum(refunded_usd) as decimal(18, 4)) as refunded_usd,
    cast(sum(fee_usd) as decimal(18, 4)) as fee_usd
from {{ ref('int__margin__activity') }}
group by report_date, merchant_id
