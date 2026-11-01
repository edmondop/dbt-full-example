select
    customer_id,
    currency_code,
    gross_spend
from {{ ref('int__customers__lifetime_spend') }}
