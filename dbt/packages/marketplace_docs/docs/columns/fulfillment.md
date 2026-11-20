# Fulfillment

{% docs shipped_at %}
UTC timestamp when the shipment left the warehouse.
{% enddocs %}

{% docs delivered_at %}
Latest UTC timestamp of a `delivered` shipment event; null when the shipment is undelivered.
{% enddocs %}

{% docs delivery_days %}
Day boundaries crossed from shipped_at to delivered_at; null when undelivered.
{% enddocs %}
