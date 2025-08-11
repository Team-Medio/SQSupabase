create table "public"."ChartData" (
    "id" character varying not null,
    "sqooped_date" timestamp with time zone not null default now(),
    "watch_system" smallint not null,
    "country_code" character varying,
    "channel_id" character varying not null,
    "sqoop_count" smallint
);


create table "public"."RecentSqoopedChannels" (
    "channel_id" character varying not null,
    "sqooped_date" timestamp with time zone not null default now()
);


CREATE UNIQUE INDEX "ChartData_pkey" ON public."ChartData" USING btree (id, sqooped_date, watch_system, channel_id);

CREATE UNIQUE INDEX "RecentSqoopedChannels_pkey" ON public."RecentSqoopedChannels" USING btree (channel_id);

alter table "public"."ChartData" add constraint "ChartData_pkey" PRIMARY KEY using index "ChartData_pkey";

alter table "public"."RecentSqoopedChannels" add constraint "RecentSqoopedChannels_pkey" PRIMARY KEY using index "RecentSqoopedChannels_pkey";

set check_function_bodies = off;

create or replace view "public"."WeeklyMostSqoopedChannels" as  SELECT s.channel_id,
    (date_trunc('week'::text, s.sqooped_date))::date AS date,
    (sum(s.sqoop_count))::smallint AS sqoop_count
   FROM "ChartData" s
  GROUP BY s.channel_id, ((date_trunc('week'::text, s.sqooped_date))::date);


CREATE OR REPLACE FUNCTION public.insert_sqooped_log(playlist_id character varying, now_date timestamp with time zone, channel_id character varying, country_code character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
    watch int;
    today_date timestamptz; -- access 변수가 필요하다면 함수의 입력으로 받거나 정의해야 함
begin
    -- 오늘 날짜의 00:00:00 설정
    today_date := date_trunc('day', now_date::timestamp);
    watch := (extract(hour from now_date::timestamp))::int / 3;

    -- "SendToPlaylistDate" 테이블에 삽입 (충돌 시 업데이트)
    insert into "ChartData"
    ("id", "watchSystem", "sqooped_date", "country_code", "channelID", "sqoop_count")
    values
    (playlist_id, watch, today_date, country_code, channel_id, 1)
    on conflict ("id", "watchSystem","sqooped_date")
    do update set "sqoop_count" = excluded."sqoop_count" + 1;

    -- "RecentSqoopedPlaylists" 테이블에 삽입 (충돌 시 업데이트)
    insert into "RecentSqoopedPlaylists" ("id", "sqooped_date")
    values (playlist_id, now_date)
    on conflict ("id")
    do update set sqooped_date = now_date;

    -- "RecentSqoopedChannels" 테이블에 삽입 (충돌 시 업데이트)
    insert into "RecentSqoopedChannels" ("channelID", "sqooped_date")
    values (channel_id, now_date)
    on conflict ("channel_id")
    do update set sqooped_date = now_date;

    return;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.insert_sqooped_log_v2(playlistid character varying, nowdate timestamp with time zone, channelid character varying, countrycode character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_today_date timestamptz;
    v_watch_system int;
BEGIN
    -- [수정됨] 파라미터 이름을 nowDate로 정확히 사용합니다.
    v_today_date := date_trunc('day', nowDate);
    v_watch_system := (extract(hour from nowDate))::int / 3;

    -- [수정됨] INSERT 문에서는 실제 테이블의 컬럼명(소문자 snake_case)을 사용합니다.
    INSERT INTO "ChartData"
    ("id", "sqooped_date", "watch_system", "channel_id", "country_code", "sqoop_count")
    VALUES
    (playlistID, v_today_date, v_watch_system, channelID, countryCode, 1)
    ON CONFLICT ("id", "sqooped_date", "watch_system", "channel_id")
    DO UPDATE SET "sqoop_count" = "ChartData"."sqoop_count" + 1;

    INSERT INTO "RecentSqoopedPlaylists" ("id", "sqooped_date")
    VALUES (playlistID, nowDate)
    ON CONFLICT ("id")
    DO UPDATE SET "sqooped_date" = nowDate;

    INSERT INTO "RecentSqoopedChannels" ("channel_id", "sqooped_date")
    VALUES (channelID, nowDate)
    ON CONFLICT ("channel_id")
    DO UPDATE SET "sqooped_date" = nowDate;

    RETURN;
END;
$function$
;

grant delete on table "public"."ChartData" to "anon";

grant insert on table "public"."ChartData" to "anon";

grant references on table "public"."ChartData" to "anon";

grant select on table "public"."ChartData" to "anon";

grant trigger on table "public"."ChartData" to "anon";

grant truncate on table "public"."ChartData" to "anon";

grant update on table "public"."ChartData" to "anon";

grant delete on table "public"."ChartData" to "authenticated";

grant insert on table "public"."ChartData" to "authenticated";

grant references on table "public"."ChartData" to "authenticated";

grant select on table "public"."ChartData" to "authenticated";

grant trigger on table "public"."ChartData" to "authenticated";

grant truncate on table "public"."ChartData" to "authenticated";

grant update on table "public"."ChartData" to "authenticated";

grant delete on table "public"."ChartData" to "service_role";

grant insert on table "public"."ChartData" to "service_role";

grant references on table "public"."ChartData" to "service_role";

grant select on table "public"."ChartData" to "service_role";

grant trigger on table "public"."ChartData" to "service_role";

grant truncate on table "public"."ChartData" to "service_role";

grant update on table "public"."ChartData" to "service_role";

grant delete on table "public"."MusicInfoJoin" to "anon";

grant insert on table "public"."MusicInfoJoin" to "anon";

grant references on table "public"."MusicInfoJoin" to "anon";

grant select on table "public"."MusicInfoJoin" to "anon";

grant trigger on table "public"."MusicInfoJoin" to "anon";

grant truncate on table "public"."MusicInfoJoin" to "anon";

grant update on table "public"."MusicInfoJoin" to "anon";

grant delete on table "public"."MusicInfoJoin" to "authenticated";

grant insert on table "public"."MusicInfoJoin" to "authenticated";

grant references on table "public"."MusicInfoJoin" to "authenticated";

grant select on table "public"."MusicInfoJoin" to "authenticated";

grant trigger on table "public"."MusicInfoJoin" to "authenticated";

grant truncate on table "public"."MusicInfoJoin" to "authenticated";

grant update on table "public"."MusicInfoJoin" to "authenticated";

grant delete on table "public"."MusicInfoJoin" to "service_role";

grant insert on table "public"."MusicInfoJoin" to "service_role";

grant references on table "public"."MusicInfoJoin" to "service_role";

grant select on table "public"."MusicInfoJoin" to "service_role";

grant trigger on table "public"."MusicInfoJoin" to "service_role";

grant truncate on table "public"."MusicInfoJoin" to "service_role";

grant update on table "public"."MusicInfoJoin" to "service_role";

grant delete on table "public"."MusicStartJoin" to "anon";

grant insert on table "public"."MusicStartJoin" to "anon";

grant references on table "public"."MusicStartJoin" to "anon";

grant select on table "public"."MusicStartJoin" to "anon";

grant trigger on table "public"."MusicStartJoin" to "anon";

grant truncate on table "public"."MusicStartJoin" to "anon";

grant update on table "public"."MusicStartJoin" to "anon";

grant delete on table "public"."MusicStartJoin" to "authenticated";

grant insert on table "public"."MusicStartJoin" to "authenticated";

grant references on table "public"."MusicStartJoin" to "authenticated";

grant select on table "public"."MusicStartJoin" to "authenticated";

grant trigger on table "public"."MusicStartJoin" to "authenticated";

grant truncate on table "public"."MusicStartJoin" to "authenticated";

grant update on table "public"."MusicStartJoin" to "authenticated";

grant delete on table "public"."MusicStartJoin" to "service_role";

grant insert on table "public"."MusicStartJoin" to "service_role";

grant references on table "public"."MusicStartJoin" to "service_role";

grant select on table "public"."MusicStartJoin" to "service_role";

grant trigger on table "public"."MusicStartJoin" to "service_role";

grant truncate on table "public"."MusicStartJoin" to "service_role";

grant update on table "public"."MusicStartJoin" to "service_role";

grant delete on table "public"."PlaylistHeadAccessDate" to "anon";

grant insert on table "public"."PlaylistHeadAccessDate" to "anon";

grant references on table "public"."PlaylistHeadAccessDate" to "anon";

grant select on table "public"."PlaylistHeadAccessDate" to "anon";

grant trigger on table "public"."PlaylistHeadAccessDate" to "anon";

grant truncate on table "public"."PlaylistHeadAccessDate" to "anon";

grant update on table "public"."PlaylistHeadAccessDate" to "anon";

grant delete on table "public"."PlaylistHeadAccessDate" to "authenticated";

grant insert on table "public"."PlaylistHeadAccessDate" to "authenticated";

grant references on table "public"."PlaylistHeadAccessDate" to "authenticated";

grant select on table "public"."PlaylistHeadAccessDate" to "authenticated";

grant trigger on table "public"."PlaylistHeadAccessDate" to "authenticated";

grant truncate on table "public"."PlaylistHeadAccessDate" to "authenticated";

grant update on table "public"."PlaylistHeadAccessDate" to "authenticated";

grant delete on table "public"."PlaylistHeadAccessDate" to "service_role";

grant insert on table "public"."PlaylistHeadAccessDate" to "service_role";

grant references on table "public"."PlaylistHeadAccessDate" to "service_role";

grant select on table "public"."PlaylistHeadAccessDate" to "service_role";

grant trigger on table "public"."PlaylistHeadAccessDate" to "service_role";

grant truncate on table "public"."PlaylistHeadAccessDate" to "service_role";

grant update on table "public"."PlaylistHeadAccessDate" to "service_role";

grant delete on table "public"."RecentSqoopedChannels" to "anon";

grant insert on table "public"."RecentSqoopedChannels" to "anon";

grant references on table "public"."RecentSqoopedChannels" to "anon";

grant select on table "public"."RecentSqoopedChannels" to "anon";

grant trigger on table "public"."RecentSqoopedChannels" to "anon";

grant truncate on table "public"."RecentSqoopedChannels" to "anon";

grant update on table "public"."RecentSqoopedChannels" to "anon";

grant delete on table "public"."RecentSqoopedChannels" to "authenticated";

grant insert on table "public"."RecentSqoopedChannels" to "authenticated";

grant references on table "public"."RecentSqoopedChannels" to "authenticated";

grant select on table "public"."RecentSqoopedChannels" to "authenticated";

grant trigger on table "public"."RecentSqoopedChannels" to "authenticated";

grant truncate on table "public"."RecentSqoopedChannels" to "authenticated";

grant update on table "public"."RecentSqoopedChannels" to "authenticated";

grant delete on table "public"."RecentSqoopedChannels" to "service_role";

grant insert on table "public"."RecentSqoopedChannels" to "service_role";

grant references on table "public"."RecentSqoopedChannels" to "service_role";

grant select on table "public"."RecentSqoopedChannels" to "service_role";

grant trigger on table "public"."RecentSqoopedChannels" to "service_role";

grant truncate on table "public"."RecentSqoopedChannels" to "service_role";

grant update on table "public"."RecentSqoopedChannels" to "service_role";

grant delete on table "public"."RecentSqoopedPlaylists" to "anon";

grant insert on table "public"."RecentSqoopedPlaylists" to "anon";

grant references on table "public"."RecentSqoopedPlaylists" to "anon";

grant select on table "public"."RecentSqoopedPlaylists" to "anon";

grant trigger on table "public"."RecentSqoopedPlaylists" to "anon";

grant truncate on table "public"."RecentSqoopedPlaylists" to "anon";

grant update on table "public"."RecentSqoopedPlaylists" to "anon";

grant delete on table "public"."RecentSqoopedPlaylists" to "authenticated";

grant insert on table "public"."RecentSqoopedPlaylists" to "authenticated";

grant references on table "public"."RecentSqoopedPlaylists" to "authenticated";

grant select on table "public"."RecentSqoopedPlaylists" to "authenticated";

grant trigger on table "public"."RecentSqoopedPlaylists" to "authenticated";

grant truncate on table "public"."RecentSqoopedPlaylists" to "authenticated";

grant update on table "public"."RecentSqoopedPlaylists" to "authenticated";

grant delete on table "public"."RecentSqoopedPlaylists" to "service_role";

grant insert on table "public"."RecentSqoopedPlaylists" to "service_role";

grant references on table "public"."RecentSqoopedPlaylists" to "service_role";

grant select on table "public"."RecentSqoopedPlaylists" to "service_role";

grant trigger on table "public"."RecentSqoopedPlaylists" to "service_role";

grant truncate on table "public"."RecentSqoopedPlaylists" to "service_role";

grant update on table "public"."RecentSqoopedPlaylists" to "service_role";

grant delete on table "public"."SendToPlaylistDate" to "anon";

grant insert on table "public"."SendToPlaylistDate" to "anon";

grant references on table "public"."SendToPlaylistDate" to "anon";

grant select on table "public"."SendToPlaylistDate" to "anon";

grant trigger on table "public"."SendToPlaylistDate" to "anon";

grant truncate on table "public"."SendToPlaylistDate" to "anon";

grant update on table "public"."SendToPlaylistDate" to "anon";

grant delete on table "public"."SendToPlaylistDate" to "authenticated";

grant insert on table "public"."SendToPlaylistDate" to "authenticated";

grant references on table "public"."SendToPlaylistDate" to "authenticated";

grant select on table "public"."SendToPlaylistDate" to "authenticated";

grant trigger on table "public"."SendToPlaylistDate" to "authenticated";

grant truncate on table "public"."SendToPlaylistDate" to "authenticated";

grant update on table "public"."SendToPlaylistDate" to "authenticated";

grant delete on table "public"."SendToPlaylistDate" to "service_role";

grant insert on table "public"."SendToPlaylistDate" to "service_role";

grant references on table "public"."SendToPlaylistDate" to "service_role";

grant select on table "public"."SendToPlaylistDate" to "service_role";

grant trigger on table "public"."SendToPlaylistDate" to "service_role";

grant truncate on table "public"."SendToPlaylistDate" to "service_role";

grant update on table "public"."SendToPlaylistDate" to "service_role";

grant delete on table "public"."Version_iOS" to "anon";

grant insert on table "public"."Version_iOS" to "anon";

grant references on table "public"."Version_iOS" to "anon";

grant select on table "public"."Version_iOS" to "anon";

grant trigger on table "public"."Version_iOS" to "anon";

grant truncate on table "public"."Version_iOS" to "anon";

grant update on table "public"."Version_iOS" to "anon";

grant delete on table "public"."Version_iOS" to "authenticated";

grant insert on table "public"."Version_iOS" to "authenticated";

grant references on table "public"."Version_iOS" to "authenticated";

grant select on table "public"."Version_iOS" to "authenticated";

grant trigger on table "public"."Version_iOS" to "authenticated";

grant truncate on table "public"."Version_iOS" to "authenticated";

grant update on table "public"."Version_iOS" to "authenticated";

grant delete on table "public"."Version_iOS" to "service_role";

grant insert on table "public"."Version_iOS" to "service_role";

grant references on table "public"."Version_iOS" to "service_role";

grant select on table "public"."Version_iOS" to "service_role";

grant trigger on table "public"."Version_iOS" to "service_role";

grant truncate on table "public"."Version_iOS" to "service_role";

grant update on table "public"."Version_iOS" to "service_role";

grant delete on table "public"."YTChannelInfo" to "anon";

grant insert on table "public"."YTChannelInfo" to "anon";

grant references on table "public"."YTChannelInfo" to "anon";

grant select on table "public"."YTChannelInfo" to "anon";

grant trigger on table "public"."YTChannelInfo" to "anon";

grant truncate on table "public"."YTChannelInfo" to "anon";

grant update on table "public"."YTChannelInfo" to "anon";

grant delete on table "public"."YTChannelInfo" to "authenticated";

grant insert on table "public"."YTChannelInfo" to "authenticated";

grant references on table "public"."YTChannelInfo" to "authenticated";

grant select on table "public"."YTChannelInfo" to "authenticated";

grant trigger on table "public"."YTChannelInfo" to "authenticated";

grant truncate on table "public"."YTChannelInfo" to "authenticated";

grant update on table "public"."YTChannelInfo" to "authenticated";

grant delete on table "public"."YTChannelInfo" to "service_role";

grant insert on table "public"."YTChannelInfo" to "service_role";

grant references on table "public"."YTChannelInfo" to "service_role";

grant select on table "public"."YTChannelInfo" to "service_role";

grant trigger on table "public"."YTChannelInfo" to "service_role";

grant truncate on table "public"."YTChannelInfo" to "service_role";

grant update on table "public"."YTChannelInfo" to "service_role";

grant delete on table "public"."YTOfficialPlaylist" to "anon";

grant insert on table "public"."YTOfficialPlaylist" to "anon";

grant references on table "public"."YTOfficialPlaylist" to "anon";

grant select on table "public"."YTOfficialPlaylist" to "anon";

grant trigger on table "public"."YTOfficialPlaylist" to "anon";

grant truncate on table "public"."YTOfficialPlaylist" to "anon";

grant update on table "public"."YTOfficialPlaylist" to "anon";

grant delete on table "public"."YTOfficialPlaylist" to "authenticated";

grant insert on table "public"."YTOfficialPlaylist" to "authenticated";

grant references on table "public"."YTOfficialPlaylist" to "authenticated";

grant select on table "public"."YTOfficialPlaylist" to "authenticated";

grant trigger on table "public"."YTOfficialPlaylist" to "authenticated";

grant truncate on table "public"."YTOfficialPlaylist" to "authenticated";

grant update on table "public"."YTOfficialPlaylist" to "authenticated";

grant delete on table "public"."YTOfficialPlaylist" to "service_role";

grant insert on table "public"."YTOfficialPlaylist" to "service_role";

grant references on table "public"."YTOfficialPlaylist" to "service_role";

grant select on table "public"."YTOfficialPlaylist" to "service_role";

grant trigger on table "public"."YTOfficialPlaylist" to "service_role";

grant truncate on table "public"."YTOfficialPlaylist" to "service_role";

grant update on table "public"."YTOfficialPlaylist" to "service_role";

grant delete on table "public"."YTPlaylistHead" to "anon";

grant insert on table "public"."YTPlaylistHead" to "anon";

grant references on table "public"."YTPlaylistHead" to "anon";

grant select on table "public"."YTPlaylistHead" to "anon";

grant trigger on table "public"."YTPlaylistHead" to "anon";

grant truncate on table "public"."YTPlaylistHead" to "anon";

grant update on table "public"."YTPlaylistHead" to "anon";

grant delete on table "public"."YTPlaylistHead" to "authenticated";

grant insert on table "public"."YTPlaylistHead" to "authenticated";

grant references on table "public"."YTPlaylistHead" to "authenticated";

grant select on table "public"."YTPlaylistHead" to "authenticated";

grant trigger on table "public"."YTPlaylistHead" to "authenticated";

grant truncate on table "public"."YTPlaylistHead" to "authenticated";

grant update on table "public"."YTPlaylistHead" to "authenticated";

grant delete on table "public"."YTPlaylistHead" to "service_role";

grant insert on table "public"."YTPlaylistHead" to "service_role";

grant references on table "public"."YTPlaylistHead" to "service_role";

grant select on table "public"."YTPlaylistHead" to "service_role";

grant trigger on table "public"."YTPlaylistHead" to "service_role";

grant truncate on table "public"."YTPlaylistHead" to "service_role";

grant update on table "public"."YTPlaylistHead" to "service_role";

grant delete on table "public"."YTVideoPlaylist" to "anon";

grant insert on table "public"."YTVideoPlaylist" to "anon";

grant references on table "public"."YTVideoPlaylist" to "anon";

grant select on table "public"."YTVideoPlaylist" to "anon";

grant trigger on table "public"."YTVideoPlaylist" to "anon";

grant truncate on table "public"."YTVideoPlaylist" to "anon";

grant update on table "public"."YTVideoPlaylist" to "anon";

grant delete on table "public"."YTVideoPlaylist" to "authenticated";

grant insert on table "public"."YTVideoPlaylist" to "authenticated";

grant references on table "public"."YTVideoPlaylist" to "authenticated";

grant select on table "public"."YTVideoPlaylist" to "authenticated";

grant trigger on table "public"."YTVideoPlaylist" to "authenticated";

grant truncate on table "public"."YTVideoPlaylist" to "authenticated";

grant update on table "public"."YTVideoPlaylist" to "authenticated";

grant delete on table "public"."YTVideoPlaylist" to "service_role";

grant insert on table "public"."YTVideoPlaylist" to "service_role";

grant references on table "public"."YTVideoPlaylist" to "service_role";

grant select on table "public"."YTVideoPlaylist" to "service_role";

grant trigger on table "public"."YTVideoPlaylist" to "service_role";

grant truncate on table "public"."YTVideoPlaylist" to "service_role";

grant update on table "public"."YTVideoPlaylist" to "service_role";



