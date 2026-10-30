select
    customer_id,
    country_code,
    signup_date
from {{ ref('platform', 'dim__customers') }}
