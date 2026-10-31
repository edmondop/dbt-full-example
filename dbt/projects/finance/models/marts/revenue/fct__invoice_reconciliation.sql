select
    invoice_id,
    order_id,
    merchant_id,
    currency_code,
    invoiced_minor,
    credited_minor,
    adjustment_minor,
    net_billed_minor
from {{ ref('int__revenue__invoice_balance') }}
