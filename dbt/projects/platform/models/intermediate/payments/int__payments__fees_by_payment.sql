select
    payment_id,
    order_id,
    cast(currency_code as varchar) as currency_code,
    amount,
    fee_minor,
    {{ marketplace_macros.minor_units_to_major('fee_minor', 'currency_code') }} as fee_amount
from {{ ref('int__payments__succeeded_attempts_with_fees') }}
