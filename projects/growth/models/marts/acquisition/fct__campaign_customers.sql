select
    campaign_id,
    count(distinct customer_id) as attributed_customers
from {{ ref('int__acquisition__touchpoints') }}
group by campaign_id
