select
    customers.customer_id,
    customers.country_code,
    countries.currency_code as home_currency_code,
    customers.created_at
from {{ ref('stg__shop__customers') }} as customers
left join {{ ref('stg__reference__countries') }} as countries on customers.country_code = countries.country_code
