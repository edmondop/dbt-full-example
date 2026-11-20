# Calendar and time

Timestamps are naive UTC. A `*_date` derived with `local_day_in_business_tz`
is the day in `var('business_timezone')`; one derived with `cast(... as date)`
is the UTC day.

{% docs activity_month %}
First day of the calendar month the row counts activity for.
{% enddocs %}
