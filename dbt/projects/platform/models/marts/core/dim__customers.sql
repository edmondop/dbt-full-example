{#- Public contract deliberately excludes email: PII stays inside platform. -#}
select
    customer_id,
    cast(country_code as varchar) as country_code,
    {{ marketplace_macros.local_day_in_business_tz('created_at') }} as signup_date,
    cast(home_currency_code as varchar) as home_currency_code,
    first_order_date,
    cast(coalesce(completed_order_count, 0) as bigint) as completed_order_count
from {{ ref('int__customers__with_order_facts') }}
