# Orders and products

Major-unit amounts divide minor units by 10^exponent from
`var('currency_minor_units')` and are `decimal(18, 4)`.

{% docs ordered_at %}
UTC timestamp when the customer placed the order.
{% enddocs %}

{% docs unit_price_minor %}
Price of one unit in minor units of the order currency.
{% enddocs %}

{% docs order_amount_minor %}
Sum of the order's line_amount_minor; 0 when the order has no lines.
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

{% docs on_hand %}
Units of the SKU in stock at the warehouse.
{% enddocs %}

{% docs completed_order_count %}
Number of the customer's completed orders; 0 when the customer has none.
{% enddocs %}

{% docs order_count %}
Number of the customer's orders in any status.
{% enddocs %}

{% docs is_completed_order %}
1 when order_status is `completed`, otherwise 0.
{% enddocs %}
