select * from {{ ref('int__fulfillment__shipments_with_delivery') }}
where delivery_days > 3
