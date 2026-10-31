{#- Public contract deliberately excludes email: PII stays inside platform. -#}
select
    customers.customer_id,
    cast(customers.country_code as varchar) as country_code,
    {{ marketplace_macros.local_day_in_business_tz('customers.created_at') }} as signup_date,
    cast(customers.home_currency_code as varchar) as home_currency_code,
    first_order.first_order_date,
    cast(coalesce(order_counts.completed_order_count, 0) as bigint) as completed_order_count
from {{ ref('int__customers__with_country_currency') }} as customers
left join {{ ref('int__customers__first_order') }} as first_order
    on customers.customer_id = first_order.customer_id
left join {{ ref('int__customers__order_counts') }} as order_counts
    on customers.customer_id = order_counts.customer_id
