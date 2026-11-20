select
    customer_id,
    first_order_date,
    cast({{ dbt.date_trunc('month', 'first_order_date') }} as date) as cohort_month
from {{ ref('int__cohorts__first_order_dates') }}
