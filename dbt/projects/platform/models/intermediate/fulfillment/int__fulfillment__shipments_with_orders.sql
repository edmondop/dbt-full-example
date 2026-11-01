select
    shipments.shipment_id,
    shipments.order_id,
    shipments.warehouse_id,
    shipments.carrier_id,
    shipments.shipped_at,
    orders.customer_id,
    orders.merchant_id,
    orders.order_date
from {{ ref('stg__fulfillment__shipments') }} as shipments
inner join {{ ref('int__orders__with_amounts') }} as orders on shipments.order_id = orders.order_id
