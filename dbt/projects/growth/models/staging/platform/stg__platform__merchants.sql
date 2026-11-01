select
    merchant_id,
    merchant_name,
    country_code,
    currency_code,
    timezone
from {{ ref('platform', 'dim__merchants') }}
