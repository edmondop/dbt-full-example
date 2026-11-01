select
    report_date,
    merchant_id,
    revenue_usd,
    refunded_usd,
    fee_usd,
    contribution_usd
from {{ ref('int__margin__merchant_day_margin') }}
where contribution_usd < 0
