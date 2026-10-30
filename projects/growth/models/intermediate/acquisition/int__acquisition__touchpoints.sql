select
    a.customer_id,
    a.campaign_id,
    c.channel,
    a.attributed_at,
    cast(a.attributed_at as date) as attribution_date
from {{ ref('stg__marketing__customer_attribution') }} as a
inner join {{ ref('stg__marketing__campaigns') }} as c on a.campaign_id = c.campaign_id
