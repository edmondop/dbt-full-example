select
    cohort_month,
    count(*) as cohort_size
from {{ ref('int__cohorts__first_order_by_customer') }}
group by cohort_month
