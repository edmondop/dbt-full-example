{#- Public contract deliberately excludes email: PII stays inside platform. -#}
select
    customer_id,
    cast(country_code as varchar) as country_code,
    {{ marketplace_macros.local_day_in_business_tz('created_at') }} as signup_date
from {{ ref('stg__shop__customers') }}
