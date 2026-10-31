select
    c.cohort_month,
    s.currency_code,
    cast(sum(s.gross_spend) as decimal(18, 4)) as gross_spend
from {{ ref('int__cohorts__first_order_by_customer') }} as c
inner join {{ ref('int__lifecycle__spend_by_currency') }} as s on c.customer_id = s.customer_id
group by c.cohort_month, s.currency_code
