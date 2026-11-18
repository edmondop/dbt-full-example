select
    invoice_id,
    order_id,
    merchant_id,
    currency_code,
    coalesce(invoiced_amount_minor, 0) as invoiced_minor,
    coalesce(credited_minor, 0) as credited_minor,
    coalesce(adjustment_minor, 0) as adjustment_minor,
    (
        coalesce(invoiced_amount_minor, 0)
        - coalesce(credited_minor, 0)
        + coalesce(adjustment_minor, 0)
    ) as net_billed_minor
from {{ ref('int__revenue__invoices_with_amounts') }}
