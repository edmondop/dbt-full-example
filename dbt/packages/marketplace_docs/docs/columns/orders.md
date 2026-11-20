# Orders and products

Major-unit amounts divide minor units by 10^exponent from
`var('currency_minor_units')` and are `decimal(18, 4)`.

{% docs currency_code %}
ISO 4217 code of the row's amounts, uppercased.
{% enddocs %}

{% docs order_status %}
Shop order status, such as `completed`.
{% enddocs %}

{% docs order_date %}
Day of ordered_at in `var('business_timezone')`.
{% enddocs %}

{% docs quantity %}
Units of the SKU on the order line.
{% enddocs %}

{% docs line_amount_minor %}
quantity × unit_price_minor, in minor units of the order currency.
{% enddocs %}

{% docs order_amount %}
order_amount_minor in major units of currency_code.
{% enddocs %}

{% docs category_name %}
Shop product category name.
{% enddocs %}

{% docs completed_orders %}
Number of completed orders.
{% enddocs %}

{% docs gross_spend %}
Sum of completed order amounts in major units of currency_code.
{% enddocs %}
