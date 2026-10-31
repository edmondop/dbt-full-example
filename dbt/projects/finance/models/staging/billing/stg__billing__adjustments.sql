select
    id as adjustment_id,
    invoice_id,
    amount_minor
from {{ source('billing', 'adjustments') }}
