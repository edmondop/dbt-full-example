select
    id as credit_note_id,
    invoice_id,
    amount_minor
from {{ source('billing', 'credit_notes') }}
