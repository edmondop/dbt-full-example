select
    customer_id,
    cast({{ dbt.date_trunc('month', 'order_date') }} as date) as activity_month,
    count(*) as completed_orders
from {{ ref('stg__platform__orders') }}
where order_status = 'completed'
group by customer_id, cast({{ dbt.date_trunc('month', 'order_date') }} as date)
