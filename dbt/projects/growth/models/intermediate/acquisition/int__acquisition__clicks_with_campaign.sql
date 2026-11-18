select
    clicks.click_id,
    clicks.customer_id,
    impressions.campaign_id
from {{ ref('stg__marketing__ad_clicks') }} as clicks
inner join {{ ref('stg__marketing__ad_impressions') }} as impressions
    on clicks.impression_id = impressions.impression_id
