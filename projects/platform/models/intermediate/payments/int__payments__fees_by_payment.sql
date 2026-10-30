select
    payments.payment_id,
    payments.order_id,
    payments.currency_code,
    payments.amount,
    fees.fee_minor,
    {{ marketplace_macros.minor_units_to_major('fees.fee_minor', 'payments.currency_code') }} as fee_amount
from {{ ref('int__payments__succeeded_attempts') }} as payments
inner join {{ ref('stg__psp__fees') }} as fees on payments.payment_id = fees.payment_id
