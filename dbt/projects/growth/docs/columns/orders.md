# Orders and products

Major-unit amounts divide minor units by 10^exponent from
`var('currency_minor_units')` and are `decimal(18, 4)`.

{% docs order_month %}
First day of order_date's month.
{% enddocs %}

{% docs units_sold %}
Sum of quantity over completed order lines.
{% enddocs %}

{% docs gross_amount_minor %}
Sum of line_amount_minor over completed order lines, in minor units of currency_code.
{% enddocs %}

{% docs total_orders %}
Number of the customer's orders in any status.
{% enddocs %}

{% docs completed_order %}
1 when order_status is `completed`, otherwise 0.
{% enddocs %}
