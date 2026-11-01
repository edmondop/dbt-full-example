select
    completed_orders,
    count(*) as customers
from {{ ref('int__lifecycle__segments') }}
group by completed_orders
