select
    customer_id,
    currency_code,
    gross_spend
from {{ ref('int__lifecycle__spend_by_currency') }}
where gross_spend >= 1000
