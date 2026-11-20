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

{% docs is_holiday %}
True when date_day appears in the reference holiday list.
{% enddocs %}

{% docs holiday_date %}
date_day when it is a reference holiday; otherwise null.
{% enddocs %}

{% docs holiday_label %}
Holiday name from the reference holiday list.
{% enddocs %}

{% docs created_at %}
UTC timestamp when the source system created the record.
{% enddocs %}

{% docs updated_at %}
UTC timestamp of the record's last update in the source system.
{% enddocs %}

{% docs loaded_at %}
UTC timestamp when the PSP export loaded the row (`_loaded_at`).
{% enddocs %}

{% docs max_loaded_at %}
Latest loaded_at among the events in the row; the incremental filter reads it.
{% enddocs %}

{% docs activity_month %}
First day of the calendar month the row counts activity for.
{% enddocs %}
