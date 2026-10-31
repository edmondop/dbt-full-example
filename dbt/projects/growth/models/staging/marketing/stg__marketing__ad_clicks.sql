select
    id as click_id,
    impression_id,
    customer_id,
    occurred_at
from {{ source('marketing', 'ad_clicks') }}
