drop trigger if exists "MaintainLatest100WithRecentSqoopedChannels" on "public"."RecentSqoopedChannels";

drop trigger if exists "MaintainLatest100WithRecentSqoopedPlaylists" on "public"."RecentSqoopedPlaylists";

revoke delete on table "public"."ChartData" from "anon";

revoke insert on table "public"."ChartData" from "anon";

revoke references on table "public"."ChartData" from "anon";

revoke select on table "public"."ChartData" from "anon";

revoke trigger on table "public"."ChartData" from "anon";

revoke truncate on table "public"."ChartData" from "anon";

revoke update on table "public"."ChartData" from "anon";

revoke delete on table "public"."ChartData" from "authenticated";

revoke insert on table "public"."ChartData" from "authenticated";

revoke references on table "public"."ChartData" from "authenticated";

revoke select on table "public"."ChartData" from "authenticated";

revoke trigger on table "public"."ChartData" from "authenticated";

revoke truncate on table "public"."ChartData" from "authenticated";

revoke update on table "public"."ChartData" from "authenticated";

revoke delete on table "public"."ChartData" from "service_role";

revoke insert on table "public"."ChartData" from "service_role";

revoke references on table "public"."ChartData" from "service_role";

revoke select on table "public"."ChartData" from "service_role";

revoke trigger on table "public"."ChartData" from "service_role";

revoke truncate on table "public"."ChartData" from "service_role";

revoke update on table "public"."ChartData" from "service_role";

revoke delete on table "public"."RecentSqoopedChannels" from "anon";

revoke insert on table "public"."RecentSqoopedChannels" from "anon";

revoke references on table "public"."RecentSqoopedChannels" from "anon";

revoke select on table "public"."RecentSqoopedChannels" from "anon";

revoke trigger on table "public"."RecentSqoopedChannels" from "anon";

revoke truncate on table "public"."RecentSqoopedChannels" from "anon";

revoke update on table "public"."RecentSqoopedChannels" from "anon";

revoke delete on table "public"."RecentSqoopedChannels" from "authenticated";

revoke insert on table "public"."RecentSqoopedChannels" from "authenticated";

revoke references on table "public"."RecentSqoopedChannels" from "authenticated";

revoke select on table "public"."RecentSqoopedChannels" from "authenticated";

revoke trigger on table "public"."RecentSqoopedChannels" from "authenticated";

revoke truncate on table "public"."RecentSqoopedChannels" from "authenticated";

revoke update on table "public"."RecentSqoopedChannels" from "authenticated";

revoke delete on table "public"."RecentSqoopedChannels" from "service_role";

revoke insert on table "public"."RecentSqoopedChannels" from "service_role";

revoke references on table "public"."RecentSqoopedChannels" from "service_role";

revoke select on table "public"."RecentSqoopedChannels" from "service_role";

revoke trigger on table "public"."RecentSqoopedChannels" from "service_role";

revoke truncate on table "public"."RecentSqoopedChannels" from "service_role";

revoke update on table "public"."RecentSqoopedChannels" from "service_role";

revoke delete on table "public"."RecentSqoopedPlaylists" from "anon";

revoke insert on table "public"."RecentSqoopedPlaylists" from "anon";

revoke references on table "public"."RecentSqoopedPlaylists" from "anon";

revoke select on table "public"."RecentSqoopedPlaylists" from "anon";

revoke trigger on table "public"."RecentSqoopedPlaylists" from "anon";

revoke truncate on table "public"."RecentSqoopedPlaylists" from "anon";

revoke update on table "public"."RecentSqoopedPlaylists" from "anon";

revoke delete on table "public"."RecentSqoopedPlaylists" from "authenticated";

revoke insert on table "public"."RecentSqoopedPlaylists" from "authenticated";

revoke references on table "public"."RecentSqoopedPlaylists" from "authenticated";

revoke select on table "public"."RecentSqoopedPlaylists" from "authenticated";

revoke trigger on table "public"."RecentSqoopedPlaylists" from "authenticated";

revoke truncate on table "public"."RecentSqoopedPlaylists" from "authenticated";

revoke update on table "public"."RecentSqoopedPlaylists" from "authenticated";

revoke delete on table "public"."RecentSqoopedPlaylists" from "service_role";

revoke insert on table "public"."RecentSqoopedPlaylists" from "service_role";

revoke references on table "public"."RecentSqoopedPlaylists" from "service_role";

revoke select on table "public"."RecentSqoopedPlaylists" from "service_role";

revoke trigger on table "public"."RecentSqoopedPlaylists" from "service_role";

revoke truncate on table "public"."RecentSqoopedPlaylists" from "service_role";

revoke update on table "public"."RecentSqoopedPlaylists" from "service_role";

revoke delete on table "public"."SendToPlaylistDate" from "anon";

revoke insert on table "public"."SendToPlaylistDate" from "anon";

revoke references on table "public"."SendToPlaylistDate" from "anon";

revoke select on table "public"."SendToPlaylistDate" from "anon";

revoke trigger on table "public"."SendToPlaylistDate" from "anon";

revoke truncate on table "public"."SendToPlaylistDate" from "anon";

revoke update on table "public"."SendToPlaylistDate" from "anon";

revoke delete on table "public"."SendToPlaylistDate" from "authenticated";

revoke insert on table "public"."SendToPlaylistDate" from "authenticated";

revoke references on table "public"."SendToPlaylistDate" from "authenticated";

revoke select on table "public"."SendToPlaylistDate" from "authenticated";

revoke trigger on table "public"."SendToPlaylistDate" from "authenticated";

revoke truncate on table "public"."SendToPlaylistDate" from "authenticated";

revoke update on table "public"."SendToPlaylistDate" from "authenticated";

revoke delete on table "public"."SendToPlaylistDate" from "service_role";

revoke insert on table "public"."SendToPlaylistDate" from "service_role";

revoke references on table "public"."SendToPlaylistDate" from "service_role";

revoke select on table "public"."SendToPlaylistDate" from "service_role";

revoke trigger on table "public"."SendToPlaylistDate" from "service_role";

revoke truncate on table "public"."SendToPlaylistDate" from "service_role";

revoke update on table "public"."SendToPlaylistDate" from "service_role";

drop view if exists "public"."WeeklyMostSqoopedChannels";

drop function if exists "public"."get_weekly_most_sqooped_channels_v1"(now_date date, limit_count integer);

drop view if exists "public"."WeeklyMostSqoopedPlaylists";

alter table "public"."ChartData" drop constraint "ChartData_pkey";

alter table "public"."RecentSqoopedChannels" drop constraint "RecentSqoopedChannels_pkey";

alter table "public"."RecentSqoopedPlaylists" drop constraint "RecentSqoopedPlaylists_pkey";

alter table "public"."SendToPlaylistDate" drop constraint "SendToPlaylistDate_pkey";

drop index if exists "public"."ChartData_pkey";

drop index if exists "public"."RecentSqoopedChannels_pkey";

drop index if exists "public"."SendToPlaylistDate_pkey";

drop index if exists "public"."RecentSqoopedPlaylists_pkey";

drop table "public"."ChartData";

drop table "public"."RecentSqoopedChannels";

drop table "public"."RecentSqoopedPlaylists";

drop table "public"."SendToPlaylistDate";

create table "public"."chart_data" (
    "id" character varying not null,
    "sqooped_date" date not null default CURRENT_DATE,
    "watch_system" smallint not null,
    "country_code" character varying,
    "channel_id" character varying not null,
    "sqoop_count" smallint
);


create table "public"."recent_sqooped_channels" (
    "channel_id" character varying not null,
    "sqooped_date" timestamp with time zone not null default now()
);


create table "public"."recent_sqooped_playlists" (
    "id" character varying not null,
    "sqooped_date" timestamp with time zone not null
);


create table "public"."send_to_playlist_date" (
    "id" character varying not null,
    "sqooped_date" date not null,
    "watch_system" smallint not null default '0'::smallint,
    "country_code" character varying,
    "sqoop_count" smallint not null default '0'::smallint
);


CREATE UNIQUE INDEX chart_data_pkey ON public.chart_data USING btree (id, sqooped_date, watch_system, channel_id);

CREATE UNIQUE INDEX recent_sqooped_channels_pkey ON public.recent_sqooped_channels USING btree (channel_id);

CREATE UNIQUE INDEX send_to_playlist_date_pkey ON public.send_to_playlist_date USING btree (id, sqooped_date, watch_system);

CREATE UNIQUE INDEX "RecentSqoopedPlaylists_pkey" ON public.recent_sqooped_playlists USING btree (id);

alter table "public"."chart_data" add constraint "chart_data_pkey" PRIMARY KEY using index "chart_data_pkey";

alter table "public"."recent_sqooped_channels" add constraint "recent_sqooped_channels_pkey" PRIMARY KEY using index "recent_sqooped_channels_pkey";

alter table "public"."recent_sqooped_playlists" add constraint "RecentSqoopedPlaylists_pkey" PRIMARY KEY using index "RecentSqoopedPlaylists_pkey";

alter table "public"."send_to_playlist_date" add constraint "send_to_playlist_date_pkey" PRIMARY KEY using index "send_to_playlist_date_pkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_weekly_most_sqooped_channels_v3(now_date date, limit_count integer)
 RETURNS TABLE(channel_id character varying, sqoop_count smallint)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY
    SELECT
      s.channel_id as channel_id,
      s.sqoop_count as sqoop_count
    FROM weekly_most_sqooped_channels AS s
      WHERE DATE_TRUNC('week', now_date)::DATE = s.date
      ORDER BY s.sqoop_count DESC, s.channel_id ASC
    LIMIT limit_count;
END
$function$
;

create or replace view "public"."weekly_most_sqooped_channels" as  SELECT s.channel_id,
    (date_trunc('week'::text, (s.sqooped_date)::timestamp with time zone))::date AS date,
    (sum(s.sqoop_count))::smallint AS sqoop_count
   FROM chart_data s
  GROUP BY s.channel_id, ((date_trunc('week'::text, (s.sqooped_date)::timestamp with time zone))::date);


create or replace view "public"."weekly_most_sqooped_playlists" as  SELECT s.id,
    (date_trunc('week'::text, (s.sqooped_date)::timestamp with time zone))::date AS date,
    (sum(s.sqoop_count))::smallint AS sqoop_count
   FROM send_to_playlist_date s
  GROUP BY s.id, ((date_trunc('week'::text, (s.sqooped_date)::timestamp with time zone))::date);


create or replace view "public"."WeeklyMostSqoopedPlaylists" as  SELECT s.id,
    (date_trunc('week'::text, (s.sqooped_date)::timestamp with time zone))::date AS date,
    (sum(s.sqoop_count))::smallint AS sqoop_count
   FROM send_to_playlist_date s
  GROUP BY s.id, ((date_trunc('week'::text, (s.sqooped_date)::timestamp with time zone))::date);


CREATE OR REPLACE FUNCTION public.get_weekly_most_sqooped_playlists_v1(now_date date, limit_count integer)
 RETURNS SETOF character varying
 LANGUAGE plpgsql
AS $function$begin
  return query
    select
      s.id as id
    from weekly_most_sqooped_playlists as s
      where DATE_TRUNC('week', now_date)::DATE = s.date
      order by s.sqoop_count desc, s.id asc
    limit limit_count;
end$function$
;

CREATE OR REPLACE FUNCTION public.getchannelplaylistids(channelid character varying, limit_count integer)
 RETURNS SETOF character varying
 LANGUAGE plpgsql
AS $function$begin
  return query
    with latest_playlists as (
      select distinct on (s.id)
        s.id as playlistID,
        s.sqooped_date
      from chart_data as s
      where s.channel_id = channelID
      order by s.id, s.sqooped_date desc
    )
    select latest_playlists.playlistID
    from latest_playlists
    order by latest_playlists.sqooped_date desc -- id로 그룹화 후 최신순 정렬
    limit limit_count;
end$function$
;

CREATE OR REPLACE FUNCTION public.insert_sqooped_log(playlist_id character varying, now_date timestamp with time zone, country_code character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$declare
    watch int;
    today_date timestamptz; -- access 변수가 필요하다면 함수의 입력으로 받거나 정의해야 함
begin
    -- 오늘 날짜의 00:00:00 설정
    today_date := date_trunc('day', now_date::timestamp);
    watch := (extract(hour from now_date::timestamp))::int / 3;

    -- "SendToPlaylistDate" 테이블에 삽입 (충돌 시 업데이트)
    insert into send_to_playlist_date
    ("id", "watch_system", "sqooped_date", "country_code", "sqoop_count")
    values 
    (playlist_id, watch, today_date, country_code, 1)
    on conflict ("id", "watch_system", "sqooped_date")
    do update set "sqoop_count" = excluded."sqoop_count" + 1;

    -- "RecentSqoopedPlaylists" 테이블에 삽입 (충돌 시 업데이트)
    insert into recent_sqooped_playlists ("id", "sqooped_date")
    values (playlist_id, now_date)
    on conflict ("id")
    do update set sqooped_date = now_date;
    return;
end;$function$
;

CREATE OR REPLACE FUNCTION public.insert_sqooped_log_v2(playlistid character varying, nowdate timestamp with time zone, channelid character varying, countrycode character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_today_date date;
    v_watch_system int;
BEGIN
    -- 파라미터 이름을 nowDate로 정확히 사용합니다.
    v_today_date := date_trunc('day', nowDate)::date;
    v_watch_system := (extract(hour from nowDate))::int / 3;

    -- INSERT 문에서는 실제 테이블의 컬럼명(소문자 snake_case)을 사용합니다.
    insert into chart_data
    (id, sqooped_date, watch_system, channel_id, country_code, sqoop_count)
    values (playlistid, v_today_date, v_watch_system, channelid, countrycode, 1)
    on conflict (id, sqooped_date, watch_system, channel_id)
    do update set sqoop_count = chart_data.sqoop_count + 1;

    -- 따옴표 제거
    insert into recent_sqooped_playlists(id, sqooped_date)
    values (playlistid, nowDate)
    on conflict (id)
    do update set sqooped_date = nowDate;


    -- [Legacy] Insert 문에 SendToPlaylistDate 테이블을 넣습니다. ~ v.1.2.2 대응 추후 삭제 대상..!
    insert into send_to_playlist_date
    (id, sqooped_date, watch_system, country_code, sqoop_count)
    values (playlistid, v_today_date, v_watch_system, countrycode, 1)
    on conflict (id, sqooped_date, watch_system)
    do update set sqoop_count = send_to_playlist_date.sqoop_count + 1;

    -- 따옴표 제거
    insert into recent_sqooped_channels(channel_id, sqooped_date)
    values (channelid, nowDate)
    on conflict (channel_id)
    do update set sqooped_date = nowDate;


    RETURN;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.maintain_latest_100_with_recent_sqooped_channels()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
    DELETE FROM recent_sqooped_channels
    WHERE id NOT IN (
        SELECT id FROM (
            SELECT id FROM recent_sqooped_channels
            ORDER BY sqooped_date DESC
            LIMIT 100
        ) AS subquery
    );
    RETURN NULL; -- AFTER 트리거에서는 RETURN NULL 사용
END;$function$
;

CREATE OR REPLACE FUNCTION public.maintain_latest_100_with_recent_sqooped_playlists()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
    DELETE FROM recent_sqooped_playlists
    WHERE id NOT IN (
        SELECT id FROM (
            SELECT id FROM recent_sqooped_playlists
            ORDER BY sqooped_date DESC
            LIMIT 100
        ) AS subquery
    );
    RETURN NULL; -- AFTER 트리거에서는 RETURN NULL 사용
END;$function$
;

grant delete on table "public"."chart_data" to "anon";

grant insert on table "public"."chart_data" to "anon";

grant references on table "public"."chart_data" to "anon";

grant select on table "public"."chart_data" to "anon";

grant trigger on table "public"."chart_data" to "anon";

grant truncate on table "public"."chart_data" to "anon";

grant update on table "public"."chart_data" to "anon";

grant delete on table "public"."chart_data" to "authenticated";

grant insert on table "public"."chart_data" to "authenticated";

grant references on table "public"."chart_data" to "authenticated";

grant select on table "public"."chart_data" to "authenticated";

grant trigger on table "public"."chart_data" to "authenticated";

grant truncate on table "public"."chart_data" to "authenticated";

grant update on table "public"."chart_data" to "authenticated";

grant delete on table "public"."chart_data" to "service_role";

grant insert on table "public"."chart_data" to "service_role";

grant references on table "public"."chart_data" to "service_role";

grant select on table "public"."chart_data" to "service_role";

grant trigger on table "public"."chart_data" to "service_role";

grant truncate on table "public"."chart_data" to "service_role";

grant update on table "public"."chart_data" to "service_role";

grant delete on table "public"."recent_sqooped_channels" to "anon";

grant insert on table "public"."recent_sqooped_channels" to "anon";

grant references on table "public"."recent_sqooped_channels" to "anon";

grant select on table "public"."recent_sqooped_channels" to "anon";

grant trigger on table "public"."recent_sqooped_channels" to "anon";

grant truncate on table "public"."recent_sqooped_channels" to "anon";

grant update on table "public"."recent_sqooped_channels" to "anon";

grant delete on table "public"."recent_sqooped_channels" to "authenticated";

grant insert on table "public"."recent_sqooped_channels" to "authenticated";

grant references on table "public"."recent_sqooped_channels" to "authenticated";

grant select on table "public"."recent_sqooped_channels" to "authenticated";

grant trigger on table "public"."recent_sqooped_channels" to "authenticated";

grant truncate on table "public"."recent_sqooped_channels" to "authenticated";

grant update on table "public"."recent_sqooped_channels" to "authenticated";

grant delete on table "public"."recent_sqooped_channels" to "service_role";

grant insert on table "public"."recent_sqooped_channels" to "service_role";

grant references on table "public"."recent_sqooped_channels" to "service_role";

grant select on table "public"."recent_sqooped_channels" to "service_role";

grant trigger on table "public"."recent_sqooped_channels" to "service_role";

grant truncate on table "public"."recent_sqooped_channels" to "service_role";

grant update on table "public"."recent_sqooped_channels" to "service_role";

grant delete on table "public"."recent_sqooped_playlists" to "anon";

grant insert on table "public"."recent_sqooped_playlists" to "anon";

grant references on table "public"."recent_sqooped_playlists" to "anon";

grant select on table "public"."recent_sqooped_playlists" to "anon";

grant trigger on table "public"."recent_sqooped_playlists" to "anon";

grant truncate on table "public"."recent_sqooped_playlists" to "anon";

grant update on table "public"."recent_sqooped_playlists" to "anon";

grant delete on table "public"."recent_sqooped_playlists" to "authenticated";

grant insert on table "public"."recent_sqooped_playlists" to "authenticated";

grant references on table "public"."recent_sqooped_playlists" to "authenticated";

grant select on table "public"."recent_sqooped_playlists" to "authenticated";

grant trigger on table "public"."recent_sqooped_playlists" to "authenticated";

grant truncate on table "public"."recent_sqooped_playlists" to "authenticated";

grant update on table "public"."recent_sqooped_playlists" to "authenticated";

grant delete on table "public"."recent_sqooped_playlists" to "service_role";

grant insert on table "public"."recent_sqooped_playlists" to "service_role";

grant references on table "public"."recent_sqooped_playlists" to "service_role";

grant select on table "public"."recent_sqooped_playlists" to "service_role";

grant trigger on table "public"."recent_sqooped_playlists" to "service_role";

grant truncate on table "public"."recent_sqooped_playlists" to "service_role";

grant update on table "public"."recent_sqooped_playlists" to "service_role";

grant delete on table "public"."send_to_playlist_date" to "anon";

grant insert on table "public"."send_to_playlist_date" to "anon";

grant references on table "public"."send_to_playlist_date" to "anon";

grant select on table "public"."send_to_playlist_date" to "anon";

grant trigger on table "public"."send_to_playlist_date" to "anon";

grant truncate on table "public"."send_to_playlist_date" to "anon";

grant update on table "public"."send_to_playlist_date" to "anon";

grant delete on table "public"."send_to_playlist_date" to "authenticated";

grant insert on table "public"."send_to_playlist_date" to "authenticated";

grant references on table "public"."send_to_playlist_date" to "authenticated";

grant select on table "public"."send_to_playlist_date" to "authenticated";

grant trigger on table "public"."send_to_playlist_date" to "authenticated";

grant truncate on table "public"."send_to_playlist_date" to "authenticated";

grant update on table "public"."send_to_playlist_date" to "authenticated";

grant delete on table "public"."send_to_playlist_date" to "service_role";

grant insert on table "public"."send_to_playlist_date" to "service_role";

grant references on table "public"."send_to_playlist_date" to "service_role";

grant select on table "public"."send_to_playlist_date" to "service_role";

grant trigger on table "public"."send_to_playlist_date" to "service_role";

grant truncate on table "public"."send_to_playlist_date" to "service_role";

grant update on table "public"."send_to_playlist_date" to "service_role";

CREATE TRIGGER "MaintainLatest100WithRecentSqoopedPlaylists" AFTER INSERT ON public.recent_sqooped_playlists FOR EACH ROW EXECUTE FUNCTION maintain_latest_100_with_recent_sqooped_playlists();


