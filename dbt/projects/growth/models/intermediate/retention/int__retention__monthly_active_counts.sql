select
    months.activity_month,
    activity.active_customers
from {{ ref('int__retention__calendar_months') }} as months
left join {{ ref('int__retention__active_customer_months') }} as activity
    on months.activity_month = activity.activity_month
