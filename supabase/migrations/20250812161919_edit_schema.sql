set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_weekly_most_sqooped_channels_v1(now_date date, limit_count integer)
 RETURNS SETOF character varying
 LANGUAGE plpgsql
AS $function$
begin
  return query
    select
      s.channel_id as channel_id
    from "WeeklyMostSqoopedChannels" as s
      where DATE_TRUNC('week', now_date)::DATE = s.date
      order by s.sqoop_count desc, s.channel_id asc
    limit limit_count;
end
$function$
;



