select
    cohorts.cohort_month,
    spend.currency_code,
    spend.gross_spend
from {{ ref('int__cohorts__first_order_by_customer') }} as cohorts
inner join {{ ref('int__lifecycle__spend_by_currency') }} as spend
    on cohorts.customer_id = spend.customer_id
