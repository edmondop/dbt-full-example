select
    shipments.shipment_id,
    shipments.order_id,
    shipments.customer_id,
    shipments.merchant_id,
    shipments.warehouse_id,
    shipments.carrier_id,
    shipments.shipped_at,
    events.delivered_at,
    cast({{ dbt.datediff('shipments.shipped_at', 'events.delivered_at', 'day') }} as integer) as delivery_days,  -- noqa: LT05
    coalesce(attempts.failed_attempts, 0) as failed_attempts
from {{ ref('int__fulfillment__shipments_with_orders') }} as shipments
left join {{ ref('int__fulfillment__shipment_event_summary') }} as events
    on shipments.shipment_id = events.shipment_id
left join {{ ref('int__fulfillment__delivery_attempt_summary') }} as attempts
    on shipments.shipment_id = attempts.shipment_id
