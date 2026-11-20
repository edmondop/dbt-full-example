# FX rates

Platform reads the ECB reference export, which quotes units of each currency
per 1 EUR on publication days. Cross rates into `var('reporting_currency')`
divide the reporting currency's quote by the converted currency's quote.

{% docs currency_code__fx %}
ISO 4217 code of the currency the rate converts from.
{% enddocs %}

{% docs currency_code__country %}
ISO 4217 code of the country's currency.
{% enddocs %}

{% docs minor_units %}
ISO 4217 minor-unit exponent: 2 for USD, 0 for JPY.
{% enddocs %}

{% docs currency_units_per_eur %}
Units of the currency named by the column prefix per 1 EUR in the ECB export; null where the export has `N/A`.
{% enddocs %}

{% docs rate_date__publication %}
ECB publication date of the quote.
{% enddocs %}

{% docs rate_date %}
Calendar date the rate applies to.
{% enddocs %}

{% docs units_per_eur %}
Units of currency_code per 1 EUR on rate_date; EUR is 1.
{% enddocs %}

{% docs reporting_units_per_eur %}
Units of the reporting currency per 1 EUR on rate_date.
{% enddocs %}

{% docs reporting_currency_code %}
ISO 4217 code of `var('reporting_currency')`.
{% enddocs %}

{% docs rate_to_reporting__published %}
Units of the reporting currency per 1 unit of currency_code on the publication date: reporting_units_per_eur / units_per_eur.
{% enddocs %}

{% docs published_rate_date %}
rate_date when the ECB published currency_code on date_day; otherwise null.
{% enddocs %}

{% docs source_rate_date %}
Latest ECB publication date on or before the day that quotes currency_code; null before the first publication.
{% enddocs %}

{% docs days_carried_forward %}
Days from source_rate_date to the day the rate applies to.
{% enddocs %}

{% docs is_carried_forward %}
True when source_rate_date is earlier than rate_date.
{% enddocs %}

{% docs source_rate_to_reporting %}
rate_to_reporting published on source_rate_date, before the carry-forward limit applies.
{% enddocs %}

{% docs rate_to_reporting %}
Units of the reporting currency per 1 unit of currency_code; null when days_carried_forward exceeds `var('fx_max_carry_forward_days')`.
{% enddocs %}

{% docs rate_to_usd %}
USD per 1 unit of currency_code: rate_to_reporting under its v1 name, with the reporting currency asserted to be USD.
{% enddocs %}

{% docs fx_rate_to_usd %}
USD per 1 unit of currency_code on payment_date; null when the day has no usable rate.
{% enddocs %}

{% docs currency_count %}
Number of reference currencies on the day.
{% enddocs %}

{% docs covered_currency_count %}
Number of reference currencies with a non-null rate_to_reporting on the day.
{% enddocs %}

{% docs missing_currency_count %}
currency_count − covered_currency_count.
{% enddocs %}

{% docs published_currency_count %}
Number of currencies the ECB quoted on the day; 0 on non-publication days.
{% enddocs %}

{% docs currency_code__reference %}
ISO 4217 currency code.
{% enddocs %}
