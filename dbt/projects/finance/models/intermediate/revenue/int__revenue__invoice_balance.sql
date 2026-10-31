with adjustments as (
    select
        invoice_id,
        sum(amount_minor) as adjustment_minor
    from {{ ref('stg__billing__adjustments') }}
    group by invoice_id
)

select
    invoices.invoice_id,
    invoices.order_id,
    invoices.merchant_id,
    invoices.currency_code,
    coalesce(invoice_lines.invoiced_amount_minor, 0) as invoiced_minor,
    coalesce(credits.credited_minor, 0) as credited_minor,
    coalesce(adjustments.adjustment_minor, 0) as adjustment_minor,
    (
        coalesce(invoice_lines.invoiced_amount_minor, 0)
        - coalesce(credits.credited_minor, 0)
        + coalesce(adjustments.adjustment_minor, 0)
    ) as net_billed_minor
from {{ ref('int__revenue__invoices_with_orders') }} as invoices
left join {{ ref('int__revenue__invoice_lines_by_invoice') }} as invoice_lines
    on invoices.invoice_id = invoice_lines.invoice_id
left join {{ ref('int__refunds__credit_notes_by_invoice') }} as credits on invoices.invoice_id = credits.invoice_id
left join adjustments on invoices.invoice_id = adjustments.invoice_id
