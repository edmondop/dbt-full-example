select
    campaigns.campaign_id,
    campaigns.channel,
    impressions.impression_count,
    clicks.click_count
from {{ ref('stg__marketing__campaigns') }} as campaigns
left join {{ ref('int__acquisition__impressions_by_campaign') }} as impressions
    on campaigns.campaign_id = impressions.campaign_id
left join {{ ref('int__acquisition__clicks_by_campaign') }} as clicks
    on campaigns.campaign_id = clicks.campaign_id
