select
    campaign_id,
    count(*) as impression_count,
    count(distinct customer_id) as reached_customers
from {{ ref('stg__marketing__ad_impressions') }}
group by campaign_id
