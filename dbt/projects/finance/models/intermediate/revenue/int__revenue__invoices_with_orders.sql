select
    i.invoice_id,
    i.issued_at,
    o.order_id,
    o.customer_id,
    o.merchant_id,
    o.currency_code,
    o.order_amount
from {{ ref('stg__billing__invoices') }} as i
inner join {{ ref('stg__platform__orders') }} as o on i.order_id = o.order_id
