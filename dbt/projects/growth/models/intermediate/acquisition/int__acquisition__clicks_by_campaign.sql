select
    campaign_id,
    count(*) as click_count,
    count(distinct customer_id) as clicking_customers
from {{ ref('int__acquisition__clicks_with_campaign') }}
group by campaign_id
