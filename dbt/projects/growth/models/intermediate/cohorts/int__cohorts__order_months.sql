select
    c.customer_id,
    c.cohort_month,
    cast({{ dbt.date_trunc('month', 'o.order_date') }} as date) as activity_month,
    o.currency_code,
    o.order_amount
from {{ ref('int__cohorts__first_order_by_customer') }} as c
inner join {{ ref('stg__platform__orders') }} as o on c.customer_id = o.customer_id
where o.order_status = 'completed'
