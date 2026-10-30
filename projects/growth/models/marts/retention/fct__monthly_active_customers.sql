select
    activity_month,
    active_customers
from {{ ref('int__retention__active_customer_months') }}
