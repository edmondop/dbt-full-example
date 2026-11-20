# Payments, refunds and payouts

PSP amounts arrive in minor units. `amount` columns are the same value in
major units of currency_code.

{% docs refund_status %}
PSP status of the refund; only `succeeded` refunds reach settlement models.
{% enddocs %}

{% docs refund_reason %}
Reason code the PSP records on the refund.
{% enddocs %}

{% docs dispute_status %}
PSP status of the dispute.
{% enddocs %}

{% docs event_at %}
UTC timestamp of the settlement event: created_at of a succeeded payment or refunded_at of a succeeded refund.
{% enddocs %}

{% docs fee_minor %}
PSP fee on the payment in minor units of the payment currency.
{% enddocs %}

{% docs fee_amount %}
fee_minor in major units of currency_code.
{% enddocs %}

{% docs available_at %}
UTC timestamp when the balance transaction's funds become available.
{% enddocs %}
