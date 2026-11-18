select
    customer_id,
    campaign_id,
    attributed_at,
    cast(attributed_at as date) as attribution_date
from {{ source('marketing', 'customer_attribution') }}
