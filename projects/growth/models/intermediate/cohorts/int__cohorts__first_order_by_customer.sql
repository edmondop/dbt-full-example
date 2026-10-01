select
    customer_id,
    min(order_date) as first_order_date,
    cast({{ dbt.date_trunc('month', 'min(order_date)') }} as date) as cohort_month
from {{ ref('stg__platform__orders') }}
where order_status = 'completed'
group by customer_id
