# Fulfillment

{% docs carrier_name %}
Carrier display name.
{% enddocs %}

{% docs tracking_code %}
Carrier tracking code from the shipping label; null when the shipment has no label.
{% enddocs %}

{% docs event_status %}
Shipment status the event records, such as `delivered`.
{% enddocs %}

{% docs event_at__shipment %}
UTC timestamp of the shipment event.
{% enddocs %}

{% docs delivered_event_at %}
event_at when event_status is `delivered`; otherwise null.
{% enddocs %}

{% docs first_event_at %}
Earliest event_at of the shipment.
{% enddocs %}

{% docs event_count %}
Number of events recorded for the shipment.
{% enddocs %}

{% docs attempt_at %}
UTC timestamp of the delivery attempt.
{% enddocs %}

{% docs outcome %}
Delivery attempt outcome, such as `failed`.
{% enddocs %}

{% docs is_failed_attempt %}
1 when outcome is `failed`, otherwise 0.
{% enddocs %}

{% docs attempt_count %}
Number of delivery attempts for the shipment.
{% enddocs %}

{% docs failed_attempts %}
Number of delivery attempts with outcome `failed`.
{% enddocs %}
