select
    report_date,
    merchant_id,
    revenue_usd,
    refunded_usd,
    fee_usd,
    cast(revenue_usd - refunded_usd - fee_usd as decimal(18, 4)) as contribution_usd
from {{ ref('int__margin__activity_by_day') }}
