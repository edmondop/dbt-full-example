select
    cohort_month,
    activity_month,
    currency_code,
    cast(sum(order_amount) as decimal(18, 4)) as gross_amount
from {{ ref('int__cohorts__order_months') }}
group by cohort_month, activity_month, currency_code
