select
    shipment_id,
    order_id,
    customer_id,
    merchant_id,
    warehouse_id,
    carrier_id,
    shipped_at,
    delivered_at,
    cast({{ dbt.datediff('shipped_at', 'delivered_at', 'day') }} as integer) as delivery_days,  -- noqa: LT05
    coalesce(failed_attempts, 0) as failed_attempts
from {{ ref('int__fulfillment__shipments_with_summaries') }}
