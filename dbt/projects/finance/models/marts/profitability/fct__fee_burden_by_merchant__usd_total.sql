{{ marketplace_macros.assert_reporting_currency('USD') }}
select
    merchant_id,
    cast(sum(fee_usd) as decimal(18, 4)) as fee_usd
from {{ ref('int__margin__fees_value_usd') }}
group by merchant_id
