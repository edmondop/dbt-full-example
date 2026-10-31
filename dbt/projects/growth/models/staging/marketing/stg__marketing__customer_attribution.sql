select
    customer_id,
    campaign_id,
    attributed_at
from {{ source('marketing', 'customer_attribution') }}
