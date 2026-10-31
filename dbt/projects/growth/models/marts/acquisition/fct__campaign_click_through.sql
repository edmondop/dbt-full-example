select
    campaign_id,
    channel,
    impression_count,
    click_count,
    cast(click_count as decimal(18, 4)) / nullif(impression_count, 0) as click_through_rate
from {{ ref('fct__campaign_reach') }}
