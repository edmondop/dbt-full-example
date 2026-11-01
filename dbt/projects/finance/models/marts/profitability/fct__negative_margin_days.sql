select
    report_date,
    merchant_id,
    revenue_usd,
    refunded_usd,
    fee_usd,
    contribution_usd
from {{ ref('int__margin__negative_margin_days') }}
