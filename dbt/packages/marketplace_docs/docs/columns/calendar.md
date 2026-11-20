# Calendar and time

Timestamps are naive UTC. A `*_date` derived with `local_day_in_business_tz`
is the day in `var('business_timezone')`; one derived with `cast(... as date)`
is the UTC day.

{% docs date_day %}
Calendar day.
{% enddocs %}

{% docs month_start %}
First day of date_day's month.
{% enddocs %}

{% docs calendar_year %}
Year of date_day.
{% enddocs %}

{% docs iso_day_of_week %}
ISO day of week of date_day: 1 is Monday, 7 is Sunday.
{% enddocs %}

{% docs is_weekend %}
True when date_day is a Saturday or Sunday.
{% enddocs %}

{% docs created_at %}
UTC timestamp when the source system created the record.
{% enddocs %}
