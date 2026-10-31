select
    t.customer_id,
    t.campaign_id,
    t.channel,
    o.order_id,
    o.merchant_id,
    merchants.country_code as merchant_country_code,
    o.order_date,
    o.order_amount
from {{ ref('int__acquisition__touchpoints') }} as t
inner join {{ ref('stg__platform__orders') }} as o on t.customer_id = o.customer_id
inner join {{ ref('stg__platform__merchants') }} as merchants on o.merchant_id = merchants.merchant_id
where
    o.order_status = 'completed'
    and {{ dbt.datediff('t.attribution_date', 'o.order_date', 'day') }} between 0 and {{ var('attribution_lookback_days') }}  -- noqa: LT05
