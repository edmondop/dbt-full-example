select
    attributions.customer_id,
    attributions.campaign_id,
    campaigns.channel,
    attributions.attributed_at,
    attributions.attribution_date
from {{ ref('stg__marketing__customer_attribution') }} as attributions
inner join {{ ref('stg__marketing__campaigns') }} as campaigns
    on attributions.campaign_id = campaigns.campaign_id
