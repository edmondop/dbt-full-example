select
    id as invoice_line_id,
    invoice_id,
    amount_minor
from {{ source('billing', 'invoice_lines') }}
