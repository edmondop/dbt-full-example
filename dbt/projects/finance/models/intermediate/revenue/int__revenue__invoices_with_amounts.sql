select
    invoices.invoice_id,
    invoices.order_id,
    invoices.merchant_id,
    invoices.currency_code,
    invoice_lines.invoiced_amount_minor,
    credits.credited_minor,
    adjustments.adjustment_minor
from {{ ref('int__revenue__invoices_with_orders') }} as invoices
left join {{ ref('int__revenue__invoice_lines_by_invoice') }} as invoice_lines
    on invoices.invoice_id = invoice_lines.invoice_id
left join {{ ref('int__refunds__credit_notes_by_invoice') }} as credits
    on invoices.invoice_id = credits.invoice_id
left join {{ ref('int__revenue__adjustments_by_invoice') }} as adjustments
    on invoices.invoice_id = adjustments.invoice_id
