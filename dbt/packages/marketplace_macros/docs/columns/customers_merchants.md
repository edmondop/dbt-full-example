# Customers and merchants

{% docs email %}
Customer email address, lowercased. Personal data; it stays inside platform.
{% enddocs %}

{% docs country_code %}
ISO 3166-1 alpha-2 country code, uppercased.
{% enddocs %}

{% docs merchant_country_code %}
ISO 3166-1 alpha-2 country code of the order's merchant.
{% enddocs %}

{% docs home_currency_code %}
ISO 4217 currency of the customer's country; null when the country is missing from the reference list.
{% enddocs %}

{% docs signup_date %}
Day of the customer's created_at in `var('business_timezone')`.
{% enddocs %}

{% docs merchant_name %}
Merchant display name.
{% enddocs %}

{% docs currency_code__merchant %}
ISO 4217 currency configured on the merchant in the shop system, uppercased.
{% enddocs %}

{% docs timezone %}
IANA time zone configured on the merchant.
{% enddocs %}

{% docs first_order_date %}
order_date of the customer's first completed order.
{% enddocs %}

{% docs second_order_date %}
Earliest order_date of a completed order after first_order_date.
{% enddocs %}

{% docs last_order_date %}
order_date of the customer's latest completed order.
{% enddocs %}

{% docs days_to_second_order %}
Days from first_order_date to second_order_date.
{% enddocs %}

{% docs lifecycle_segment %}
`loyal` at 10 or more completed orders, `repeat` at 2–9, `new` at 1, `prospect` at 0.
{% enddocs %}

{% docs customers %}
Number of customers.
{% enddocs %}

{% docs cohort_month %}
First day of the month of the customer's first completed order.
{% enddocs %}

{% docs cohort_size %}
Number of customers in the cohort.
{% enddocs %}

{% docs months_since_first_order %}
Whole calendar months from cohort_month to activity_month.
{% enddocs %}

{% docs active_customers %}
Number of distinct customers with a completed order in the month.
{% enddocs %}

{% docs active_months %}
Number of distinct months with a completed order by the customer.
{% enddocs %}

{% docs repeat_customers %}
Number of customers with completed orders in more than one month.
{% enddocs %}

{% docs retention_rate %}
active_customers / cohort_size.
{% enddocs %}

{% docs average_completed_orders %}
Mean completed_orders per customer, rounded to 2 decimals; customers without orders are excluded from the mean.
{% enddocs %}

{% docs failed_payment_attempts %}
Number of the customer's payment attempts with status `failed`.
{% enddocs %}
