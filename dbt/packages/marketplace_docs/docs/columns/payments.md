# Payments, refunds and payouts

PSP amounts arrive in minor units. `amount` columns are the same value in
major units of currency_code. `*_usd` columns multiply the major-unit amount by
fx_rate_to_usd.

{% docs amount_minor %}
Amount in ISO 4217 minor units, as the source system stores it (cents for USD, yen for JPY).
{% enddocs %}

{% docs amount %}
amount_minor in major units of currency_code.
{% enddocs %}

{% docs payment_status %}
PSP outcome of the payment attempt: `succeeded` or `failed`.
{% enddocs %}

{% docs refunded_at %}
UTC timestamp when the PSP created the refund.
{% enddocs %}

{% docs payment_date %}
Day of the settlement event in `var('business_timezone')`.
{% enddocs %}

{% docs gross_amount %}
Succeeded payment amount in major units of currency_code; refund events contribute 0.
{% enddocs %}

{% docs refunded_amount %}
Succeeded refund amount in major units of currency_code; payment events contribute 0.
{% enddocs %}

{% docs net_amount %}
gross_amount minus refunded_amount, in major units of currency_code; negative on refund-heavy days.
{% enddocs %}

{% docs net_minor %}
Net amount of the PSP balance transaction, after fees, in minor units of the payment currency.
{% enddocs %}

{% docs paid_at %}
UTC timestamp when the PSP paid the payout.
{% enddocs %}

{% docs gross_amount_usd %}
gross_amount × fx_rate_to_usd.
{% enddocs %}

{% docs refunded_amount_usd %}
refunded_amount × fx_rate_to_usd.
{% enddocs %}

{% docs net_amount_usd %}
net_amount × fx_rate_to_usd; null when payment_date has no usable rate.
{% enddocs %}
