select
    customer_id,
    cohort_month,
    count(distinct activity_month) as active_months
from {{ ref('int__cohorts__order_months') }}
group by customer_id, cohort_month
having count(distinct activity_month) > 1
