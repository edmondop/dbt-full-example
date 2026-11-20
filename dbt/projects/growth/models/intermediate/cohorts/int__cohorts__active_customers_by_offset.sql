select
    cohort_month,
    months_since_first_order,
    count(distinct customer_id) as active_customers
from {{ ref('int__cohorts__cohort_activity_offsets') }}
group by cohort_month, months_since_first_order
