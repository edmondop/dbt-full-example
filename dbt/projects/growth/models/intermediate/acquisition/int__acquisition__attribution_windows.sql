{#- Orders on attribution_date through attribution_window_end (inclusive) are attributed. -#}
select
    customer_id,
    campaign_id,
    channel,
    attribution_date,
    cast(
        {{ dbt.dateadd('day', var('attribution_lookback_days'), 'attribution_date') }} as date
    ) as attribution_window_end
from {{ ref('int__acquisition__touchpoints') }}
