{{ marketplace_macros.assert_reporting_currency('USD') }}
select
    revenue_month,
    merchant_id,
    completed_orders,
    revenue_usd
from {{ ref('int__revenue__monthly_by_merchant') }}
