select
    activity_month,
    count(distinct customer_id) as active_customers
from {{ ref('int__retention__monthly_activity') }}
group by activity_month
