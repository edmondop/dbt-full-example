# Payments, refunds and payouts

PSP amounts arrive in minor units. `amount` columns are the same value in
major units of currency_code.

{% docs refund_date %}
UTC calendar date of refunded_at.
{% enddocs %}

{% docs refund_month %}
First day of payment_date's month.
{% enddocs %}

{% docs gross_amount__payout %}
amount of the paid-out payment attempt in major units of currency_code; null when fct__payment_attempts has no row for payment_id.
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

{% docs fee_amount__derived %}
Payment gross_amount minus the payout's net_minor in major units, in major units of currency_code.
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
