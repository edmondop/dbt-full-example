select
    id as campaign_id,
    channel
from {{ source('marketing', 'campaigns') }}
