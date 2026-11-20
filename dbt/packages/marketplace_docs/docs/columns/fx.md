# FX rates

Platform reads the ECB reference export, which quotes units of each currency
per 1 EUR on publication days. Cross rates into `var('reporting_currency')`
divide the reporting currency's quote by the converted currency's quote.

{% docs currency_code__fx %}
ISO 4217 code of the currency the rate converts from.
{% enddocs %}

{% docs rate_date %}
Calendar date the rate applies to.
{% enddocs %}

{% docs source_rate_date %}
Latest ECB publication date on or before the day that quotes currency_code; null before the first publication.
{% enddocs %}

{% docs rate_to_usd %}
USD per 1 unit of currency_code: rate_to_reporting under its v1 name, with the reporting currency asserted to be USD.
{% enddocs %}

{% docs fx_rate_to_usd %}
USD per 1 unit of currency_code on payment_date; null when the day has no usable rate.
{% enddocs %}
