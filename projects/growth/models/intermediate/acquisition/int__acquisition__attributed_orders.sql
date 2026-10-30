select
    t.customer_id,
    t.campaign_id,
    t.channel,
    o.order_id,
    o.order_date,
    o.order_amount
from {{ ref('int__acquisition__touchpoints') }} as t
inner join {{ ref('stg__platform__orders') }} as o on t.customer_id = o.customer_id
where
    o.order_status = 'completed'
    and {{ dbt.datediff('t.attribution_date', 'o.order_date', 'day') }} between 0 and {{ var('attribution_lookback_days') }}  -- noqa: LT05
