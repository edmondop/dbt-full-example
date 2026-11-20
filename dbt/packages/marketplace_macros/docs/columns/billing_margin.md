# Billing, tax and margin

Billing amounts are minor units of the invoiced order's currency. USD columns
multiply a major-unit amount by platform's `rate_to_usd` for the row's date and
are null when that day has no usable rate.

{% docs issued_at %}
UTC timestamp when billing issued the invoice.
{% enddocs %}

{% docs line_count %}
Number of lines on the invoice.
{% enddocs %}

{% docs invoiced_amount_minor %}
Sum of the invoice's line amounts in minor units.
{% enddocs %}

{% docs invoiced_minor %}
invoiced_amount_minor; 0 when the invoice has no lines.
{% enddocs %}

{% docs credit_note_count %}
Number of credit notes issued against the invoice.
{% enddocs %}

{% docs credited_minor %}
Sum of the invoice's credit note amounts in minor units.
{% enddocs %}

{% docs adjustment_minor %}
Sum of the invoice's adjustment amounts in minor units; a positive adjustment increases the billed amount.
{% enddocs %}

{% docs net_billed_minor %}
invoiced_minor − credited_minor + adjustment_minor.
{% enddocs %}

{% docs rate_percent %}
Tax rate in percent for the country.
{% enddocs %}

{% docs estimated_tax %}
order_amount × rate_percent / 100, in major units of currency_code.
{% enddocs %}

{% docs order_amount_usd %}
order_amount × rate_to_usd on order_date.
{% enddocs %}

{% docs revenue_month %}
First day of order_date's month.
{% enddocs %}

{% docs revenue_usd %}
Completed order amounts in USD at each order_date's rate. sum() skips orders without a rate.
{% enddocs %}

{% docs refunded_usd %}
Refund amount × rate_to_usd on refund_date.
{% enddocs %}

{% docs fee_usd %}
Derived fee amount × rate_to_usd on payout_date.
{% enddocs %}

{% docs contribution_usd %}
revenue_usd − refunded_usd − fee_usd.
{% enddocs %}

{% docs report_date %}
Date the USD movement is booked on: order_date for revenue, refund_date for refunds, payout_date for fees.
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
