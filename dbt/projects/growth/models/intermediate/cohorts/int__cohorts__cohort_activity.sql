select
    cohorts.customer_id,
    cohorts.cohort_month,
    activity.activity_month
from {{ ref('int__cohorts__first_order_by_customer') }} as cohorts
inner join {{ ref('int__retention__monthly_activity') }} as activity
    on cohorts.customer_id = activity.customer_id
