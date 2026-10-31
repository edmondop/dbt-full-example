select
    cohort_month,
    count(*) as repeat_customers
from {{ ref('int__cohorts__repeat_customers') }}
group by cohort_month
