select
    country_code,
    count(*) as customers,
    cast(avg(completed_orders) as decimal(9, 2)) as average_completed_orders
from {{ ref('int__lifecycle__customers_with_order_counts') }}
group by country_code
