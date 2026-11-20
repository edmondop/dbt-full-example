select
    campaign_id,
    channel,
    coalesce(impression_count, 0) as impression_count,
    coalesce(click_count, 0) as click_count
from {{ ref('int__acquisition__campaign_reach_counts') }}
