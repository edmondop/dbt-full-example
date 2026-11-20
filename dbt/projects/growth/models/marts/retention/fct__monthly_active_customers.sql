select
    activity_month,
    coalesce(active_customers, 0) as active_customers
from {{ ref('int__retention__monthly_active_counts') }}
