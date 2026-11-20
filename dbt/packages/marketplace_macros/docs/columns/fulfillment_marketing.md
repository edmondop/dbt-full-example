# Fulfillment and marketing

{% docs carrier_name %}
Carrier display name.
{% enddocs %}

{% docs tracking_code %}
Carrier tracking code from the shipping label; null when the shipment has no label.
{% enddocs %}

{% docs shipped_at %}
UTC timestamp when the shipment left the warehouse.
{% enddocs %}

{% docs delivered_at %}
Latest UTC timestamp of a `delivered` shipment event; null when the shipment is undelivered.
{% enddocs %}

{% docs delivery_days %}
Day boundaries crossed from shipped_at to delivered_at; null when undelivered.
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

{% docs delayed_shipment %}
1 when delivery_days is greater than 3, otherwise 0.
{% enddocs %}

{% docs delayed_shipments %}
Number of shipments with delivery_days greater than 3.
{% enddocs %}

{% docs shipments %}
Number of shipments.
{% enddocs %}

{% docs average_delivery_days %}
Mean delivery_days, rounded to 2 decimals; undelivered shipments are excluded.
{% enddocs %}

{% docs channel %}
Acquisition channel of the campaign.
{% enddocs %}

{% docs occurred_at %}
UTC timestamp of the ad event.
{% enddocs %}

{% docs impression_count %}
Number of ad impressions for the campaign.
{% enddocs %}

{% docs reached_customers %}
Number of distinct customers with an impression from the campaign.
{% enddocs %}

{% docs click_count %}
Number of ad clicks for the campaign.
{% enddocs %}

{% docs clicking_customers %}
Number of distinct customers with a click on the campaign.
{% enddocs %}

{% docs click_through_rate %}
click_count / impression_count; null when impression_count is 0.
{% enddocs %}

{% docs attributed_at %}
UTC timestamp when marketing attributed the customer to the campaign.
{% enddocs %}

{% docs attribution_date %}
UTC calendar date of attributed_at.
{% enddocs %}

{% docs attribution_window_end %}
attribution_date plus `var('attribution_lookback_days')`; completed orders through this date are attributed.
{% enddocs %}

{% docs attributed_customers %}
Number of distinct attributed customers.
{% enddocs %}

{% docs attributed_orders %}
Number of distinct completed orders inside an attribution window.
{% enddocs %}

{% docs sent_at %}
UTC timestamp when the lifecycle email was sent.
{% enddocs %}

{% docs sent_date %}
UTC calendar date of sent_at.
{% enddocs %}

{% docs response_window_end %}
sent_date plus `var('email_response_days')`; completed orders from sent_date through this date count as responses.
{% enddocs %}

{% docs completed_orders_within_window %}
Number of the customer's completed orders from sent_date through response_window_end.
{% enddocs %}
