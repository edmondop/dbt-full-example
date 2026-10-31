with activity as (
    select
        order_date as report_date,
        merchant_id,
        order_amount_usd as revenue_usd,
        cast(0 as decimal(18, 4)) as refunded_usd,
        cast(0 as decimal(18, 4)) as fee_usd
    from {{ ref('int__margin__order_value_usd') }}

    union all

    select
        refund_date as report_date,
        merchant_id,
        cast(0 as decimal(18, 4)) as revenue_usd,
        refunded_usd,
        cast(0 as decimal(18, 4)) as fee_usd
    from {{ ref('int__margin__refund_value_usd') }}

    union all

    select
        payout_date as report_date,
        merchant_id,
        cast(0 as decimal(18, 4)) as revenue_usd,
        cast(0 as decimal(18, 4)) as refunded_usd,
        fee_usd
    from {{ ref('int__margin__fees_value_usd') }}
),

by_day as (
    select
        report_date,
        merchant_id,
        cast(sum(revenue_usd) as decimal(18, 4)) as revenue_usd,
        cast(sum(refunded_usd) as decimal(18, 4)) as refunded_usd,
        cast(sum(fee_usd) as decimal(18, 4)) as fee_usd
    from activity
    group by report_date, merchant_id
)

select
    report_date,
    merchant_id,
    revenue_usd,
    refunded_usd,
    fee_usd,
    cast(revenue_usd - refunded_usd - fee_usd as decimal(18, 4)) as contribution_usd
from by_day
