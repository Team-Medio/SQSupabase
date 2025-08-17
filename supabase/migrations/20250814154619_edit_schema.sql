
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

    -- [Legacy] Insert 문에 SendToPlaylistDate 테이블을 넣습니다. ~ v.1.2.2 대응 추후 삭제 대상..!
    INSERT INTO "SendToPlaylistDate"
    ("id", "sqooped_date", "watchSystem", "country_code", "sqoop_count")
    values
    (playlistid, v_today_date, v_watch_system, countryCode, 1)
    ON CONFLICT ("id", "sqooped_date", "watchSystem")
    DO UPDATE SET "sqoop_count" = "SendToPlaylistDate".sqoop_count + 1;

    -- [수정됨] INSERT 문에서는 실제 테이블의 컬럼명(소문자 snake_case)을 사용합니다.
    INSERT INTO "ChartData"
    ("id", "sqooped_date", "watch_system", "channel_id", "country_code", "sqoop_count")
    VALUES
    (playlistid, v_today_date, v_watch_system, channelid, countryCode, 1)
    ON CONFLICT ("id", "sqooped_date", "watch_system", "channel_id")
    DO UPDATE SET "sqoop_count" = "ChartData"."sqoop_count" + 1;

    INSERT INTO "RecentSqoopedPlaylists" ("id", "sqooped_date")
    VALUES (playlistid, nowDate)
    ON CONFLICT ("id")
    DO UPDATE SET "sqooped_date" = nowDate;

    INSERT INTO "RecentSqoopedChannels" ("channel_id", "sqooped_date")
    VALUES (channelid, nowDate)
    ON CONFLICT ("channel_id")
    DO UPDATE SET "sqooped_date" = nowDate;

    RETURN;
END;
$function$
;