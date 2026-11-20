# Payments, refunds and payouts

PSP amounts arrive in minor units. `amount` columns are the same value in
major units of currency_code.

{% docs amount_minor %}
Amount in ISO 4217 minor units, as the source system stores it (cents for USD, yen for JPY).
{% enddocs %}

{% docs amount %}
amount_minor in major units of currency_code.
{% enddocs %}

{% docs payment_status %}
PSP outcome of the payment attempt: `succeeded` or `failed`.
{% enddocs %}

{% docs refund_status %}
PSP status of the refund; only `succeeded` refunds reach settlement models.
{% enddocs %}

{% docs refund_reason %}
Reason code the PSP records on the refund.
{% enddocs %}

{% docs refunded_at %}
UTC timestamp when the PSP created the refund.
{% enddocs %}

{% docs refund_date %}
UTC calendar date of refunded_at.
{% enddocs %}

{% docs refund_month %}
First day of payment_date's month.
{% enddocs %}

{% docs dispute_status %}
PSP status of the dispute.
{% enddocs %}

{% docs event_at %}
UTC timestamp of the settlement event: created_at of a succeeded payment or refunded_at of a succeeded refund.
{% enddocs %}

{% docs payment_date %}
Day of the settlement event in `var('business_timezone')`.
{% enddocs %}

{% docs gross_amount %}
Succeeded payment amount in major units of currency_code; refund events contribute 0.
{% enddocs %}

{% docs gross_amount__payout %}
amount of the paid-out payment attempt in major units of currency_code; null when fct__payment_attempts has no row for payment_id.
{% enddocs %}

{% docs gross_amount__orders %}
Sum of completed order amounts in major units of currency_code.
{% enddocs %}

{% docs refunded_amount %}
Succeeded refund amount in major units of currency_code; payment events contribute 0.
{% enddocs %}

{% docs net_amount %}
gross_amount minus refunded_amount, in major units of currency_code; negative on refund-heavy days.
{% enddocs %}

{% docs refund_count %}
Number of succeeded refunds.
{% enddocs %}

{% docs refunded_orders %}
Number of completed orders with at least one refund.
{% enddocs %}

{% docs refund_rate %}
refunded_orders / completed_orders; null when completed_orders is 0.
{% enddocs %}

{% docs fee_minor %}
PSP fee on the payment in minor units of the payment currency.
{% enddocs %}

{% docs fee_amount %}
fee_minor in major units of currency_code.
{% enddocs %}

{% docs fee_amount__derived %}
Payment gross_amount minus the payout's net_minor in major units, in major units of currency_code.
{% enddocs %}

{% docs net_minor %}
Net amount of the PSP balance transaction, after fees, in minor units of the payment currency.
{% enddocs %}

{% docs available_at %}
UTC timestamp when the balance transaction's funds become available.
{% enddocs %}

{% docs paid_at %}
UTC timestamp when the PSP paid the payout.
{% enddocs %}

{% docs payout_date %}
UTC calendar date of paid_at.
{% enddocs %}

{% docs payout_count %}
Number of payouts.
{% enddocs %}

{% docs lag_days %}
Days from the payment attempt's created_at to the payout's paid_at.
{% enddocs %}

{% docs average_lag_days %}
Mean lag_days, rounded to 2 decimals.
{% enddocs %}

{% docs maximum_lag_days %}
Largest lag_days.
{% enddocs %}
