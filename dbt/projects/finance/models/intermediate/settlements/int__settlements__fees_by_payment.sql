select
    payment_id,
    merchant_id,
    cast(paid_at as date) as payout_date,
    currency_code,
    cast(gross_amount - {{ marketplace_macros.minor_units_to_major('net_minor', 'currency_code') }} as decimal(18, 4))
        as fee_amount
from {{ ref('int__settlements__payouts_with_attempts') }}
where gross_amount is not null
