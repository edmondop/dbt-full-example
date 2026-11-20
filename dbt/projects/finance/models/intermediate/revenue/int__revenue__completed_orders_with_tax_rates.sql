select
    orders.order_id,
    orders.merchant_id,
    orders.order_date,
    orders.currency_code,
    orders.order_amount,
    tax_rates.rate_percent
from {{ ref('int__revenue__completed_orders') }} as orders
inner join {{ ref('stg__platform__merchants') }} as merchants
    on orders.merchant_id = merchants.merchant_id
inner join {{ ref('stg__billing__tax_rates') }} as tax_rates
    on merchants.country_code = tax_rates.country_code
