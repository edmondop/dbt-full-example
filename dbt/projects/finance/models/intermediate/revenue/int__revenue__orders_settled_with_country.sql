select
    orders.order_id,
    merchants.country_code,
    orders.order_amount_usd
from {{ ref('int__revenue__orders_settled') }} as orders
inner join {{ ref('stg__platform__merchants') }} as merchants
    on orders.merchant_id = merchants.merchant_id
