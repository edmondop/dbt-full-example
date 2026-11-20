# Customers and merchants

{% docs country_code %}
ISO 3166-1 alpha-2 country code, uppercased.
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
