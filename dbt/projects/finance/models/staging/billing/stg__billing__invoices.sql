select
    id as invoice_id,
    order_id,
    issued_at
from {{ source('billing', 'invoices') }}
