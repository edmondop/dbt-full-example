select
    id as balance_transaction_id,
    payment_id,
    net_minor,
    available_at
from {{ source('psp', 'balance_transactions') }}
