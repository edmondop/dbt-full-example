select
    c.campaign_id,
    c.channel,
    coalesce(i.impression_count, 0) as impression_count,
    coalesce(k.click_count, 0) as click_count
from {{ ref('stg__marketing__campaigns') }} as c
left join {{ ref('int__acquisition__impressions_by_campaign') }} as i on c.campaign_id = i.campaign_id
left join {{ ref('int__acquisition__clicks_by_campaign') }} as k on c.campaign_id = k.campaign_id
