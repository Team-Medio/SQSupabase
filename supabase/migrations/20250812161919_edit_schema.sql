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



