{{ marketplace_macros.assert_reporting_currency('USD') }}
select
    merchant_id,
    cast(sum(contribution_usd) as decimal(18, 4)) as contribution_usd
from {{ ref('int__margin__merchant_day_margin') }}
group by merchant_id
