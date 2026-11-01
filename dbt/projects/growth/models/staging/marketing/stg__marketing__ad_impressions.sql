select
    id as impression_id,
    customer_id,
    campaign_id,
    occurred_at
from {{ source('marketing', 'ad_impressions') }}
