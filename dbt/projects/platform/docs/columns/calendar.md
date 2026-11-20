# Calendar and time

Timestamps are naive UTC. A `*_date` derived with `local_day_in_business_tz`
is the day in `var('business_timezone')`; one derived with `cast(... as date)`
is the UTC day.

{% docs is_holiday %}
True when date_day appears in the reference holiday list.
{% enddocs %}

{% docs holiday_date %}
date_day when it is a reference holiday; otherwise null.
{% enddocs %}

{% docs holiday_label %}
Holiday name from the reference holiday list.
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
