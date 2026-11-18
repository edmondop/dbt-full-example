select month_start as activity_month
from {{ ref('stg__platform__calendar') }}
group by month_start
