select
    customer_id,
    cohort_month,
    active_months
from {{ ref('int__cohorts__customer_active_months') }}
where active_months > 1
