select
    i.campaign_id,
    count(*) as click_count,
    count(distinct c.customer_id) as clicking_customers
from {{ ref('stg__marketing__ad_clicks') }} as c
inner join {{ ref('stg__marketing__ad_impressions') }} as i on c.impression_id = i.impression_id
group by i.campaign_id
