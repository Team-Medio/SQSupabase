drop function if exists "public"."insert_sqooped_log"(playlist_id character varying, now_date timestamp with time zone, channel_id character varying, country_code character varying);

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

CREATE OR REPLACE FUNCTION public.getchannelplaylistids(channelid character varying, limit_count integer)
 RETURNS SETOF character varying
 LANGUAGE plpgsql
AS $function$
begin
  return query
    with latest_playlists as (
      select distinct on (s.id)
        s.id as playlistID,
        s.sqooped_date
      from "ChartData" as s
      where s.channel_id = channelID
      order by s.id, s.sqooped_date desc
    )
    select latest_playlists.playlistID
    from latest_playlists
    order by latest_playlists.sqooped_date desc -- id로 그룹화 후 최신순 정렬
    limit limit_count;
end
$function$
;

CREATE OR REPLACE FUNCTION public.getchannelplaylists(channelid character varying, limit_count integer)
 RETURNS SETOF character varying
 LANGUAGE plpgsql
AS $function$
begin
  return query
    with latest_playlists as (
      select distinct on (s.id)
        s.id as playlistID,
        s.sqooped_date
      from "ChartData" as s
      where s.channel_id = channelID
      order by s.id, s.sqooped_date desc
    )
    select latest_playlists.playlistID
    from latest_playlists
    order by latest_playlists.sqooped_date desc -- id로 그룹화 후 최신순 정렬
    limit limit_count;
end
$function$
;

CREATE OR REPLACE FUNCTION public.maintain_latest_100_with_recent_sqooped_channels()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    DELETE FROM "RecentSqoopedChannels"
    WHERE id NOT IN (
        SELECT id FROM (
            SELECT id FROM "RecentSqoopedChannels"
            ORDER BY sqooped_date DESC
            LIMIT 100
        ) AS subquery
    );
    RETURN NULL; -- AFTER 트리거에서는 RETURN NULL 사용
END;
$function$
;

CREATE TRIGGER "MaintainLatest100WithRecentSqoopedChannels" AFTER INSERT ON public."RecentSqoopedChannels" FOR EACH ROW EXECUTE FUNCTION maintain_latest_100_with_recent_sqooped_channels();



