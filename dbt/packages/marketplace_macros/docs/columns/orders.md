# Orders and products

Major-unit amounts divide minor units by 10^exponent from
`var('currency_minor_units')` and are `decimal(18, 4)`.

{% docs currency_code %}
ISO 4217 code of the row's amounts, uppercased.
{% enddocs %}

{% docs order_status %}
Shop order status, such as `completed`.
{% enddocs %}

{% docs ordered_at %}
UTC timestamp when the customer placed the order.
{% enddocs %}

{% docs order_date %}
Day of ordered_at in `var('business_timezone')`.
{% enddocs %}

{% docs order_month %}
First day of order_date's month.
{% enddocs %}

{% docs quantity %}
Units of the SKU on the order line.
{% enddocs %}

{% docs unit_price_minor %}
Price of one unit in minor units of the order currency.
{% enddocs %}

{% docs line_amount_minor %}
quantity × unit_price_minor, in minor units of the order currency.
{% enddocs %}

{% docs order_amount_minor %}
Sum of the order's line_amount_minor; 0 when the order has no lines.
{% enddocs %}

{% docs order_amount %}
order_amount_minor in major units of currency_code.
{% enddocs %}

{% docs discount_percent %}
Percentage discount the promotion grants.
{% enddocs %}

{% docs applied_discount_percent %}
discount_percent of the order's promotion; null when the order has no discount.
{% enddocs %}

{% docs discount_count %}
Number of discounts applied to the order.
{% enddocs %}

{% docs discount_amount_minor %}
Sum of the order's discount amounts in minor units of the order currency.
{% enddocs %}

{% docs net_order_amount %}
order_amount minus discount_amount_minor converted to major units.
{% enddocs %}

{% docs category_name %}
Shop product category name.
{% enddocs %}

{% docs on_hand %}
Units of the SKU in stock at the warehouse.
{% enddocs %}

{% docs units_sold %}
Sum of quantity over completed order lines.
{% enddocs %}

{% docs gross_amount_minor %}
Sum of line_amount_minor over completed order lines, in minor units of currency_code.
{% enddocs %}

{% docs completed_orders %}
Number of completed orders.
{% enddocs %}

{% docs completed_order_count %}
Number of the customer's completed orders; 0 when the customer has none.
{% enddocs %}

{% docs order_count %}
Number of the customer's orders in any status.
{% enddocs %}

{% docs total_orders %}
Number of the customer's orders in any status.
{% enddocs %}

{% docs is_completed_order %}
1 when order_status is `completed`, otherwise 0.
{% enddocs %}

{% docs completed_order %}
1 when order_status is `completed`, otherwise 0.
{% enddocs %}

{% docs gross_spend %}
Sum of completed order amounts in major units of currency_code.
{% enddocs %}
