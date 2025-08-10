

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";






CREATE EXTENSION IF NOT EXISTS "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."ChartWatchSystem" AS ENUM (
    'First',
    'Second',
    'Third',
    'Fourth',
    'Fifth',
    'Sixth',
    'Seventh',
    'Eighth'
);


ALTER TYPE "public"."ChartWatchSystem" OWNER TO "postgres";


COMMENT ON TYPE "public"."ChartWatchSystem" IS '차트에서 사용하는 스쿱한 시간대';



CREATE TYPE "public"."MusicPlatform" AS ENUM (
    'Apple',
    'Spotify'
);


ALTER TYPE "public"."MusicPlatform" OWNER TO "postgres";


COMMENT ON TYPE "public"."MusicPlatform" IS '음악 플랫폼 타입';



CREATE TYPE "public"."YTPlaylistType" AS ENUM (
    'Official',
    'Video'
);


ALTER TYPE "public"."YTPlaylistType" OWNER TO "postgres";


COMMENT ON TYPE "public"."YTPlaylistType" IS '유튜브 플레이리스트 타입';



CREATE OR REPLACE FUNCTION "public"."findPlaylistMusics"() RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$BEGIN
END;$$;


ALTER FUNCTION "public"."findPlaylistMusics"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_is_shazamed"("playlistid" character varying) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  is_shazamed BOOLEAN; -- 결과를 저장할 변수 선언
BEGIN
    SELECT "isShazamed" 
    INTO is_shazamed
    FROM "YTPlaylistHead" AS head
    WHERE head."id" = playlistid;

    RETURN is_shazamed; -- 변수 값을 반환
end
$$;


ALTER FUNCTION "public"."get_is_shazamed"("playlistid" character varying) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_weekly_most_sqooped_playlists_v1"("now_date" "date", "limit_count" integer) RETURNS SETOF character varying
    LANGUAGE "plpgsql"
    AS $$
begin
  return query
    select
      s.id as id
    from "WeeklyMostSqoopedPlaylists" as s
      where DATE_TRUNC('week', now_date)::DATE = s.date
      order by s.sqoop_count desc, s.id asc
    limit limit_count;
end
$$;


ALTER FUNCTION "public"."get_weekly_most_sqooped_playlists_v1"("now_date" "date", "limit_count" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."getheaddatas"("ids" character varying[]) RETURNS TABLE("id" character varying, "originURL" "text", "title" "text", "thumbnailURLString" "text", "insertedDate" timestamp with time zone, "isShazamed" boolean, "playlistType" "public"."YTPlaylistType", "channelID" character varying, "channelName" "text")
    LANGUAGE "plpgsql"
    AS $$
begin
  return query
  select 
   head.id as "id",
   head."originURL" as "originURL",
   head."title" as "title",
   head."thumbnailURLString" as "thumbnailURLString",
   head."insertedDate" as "insertedDate",
   head."isShazamed" as "isShazamed",
   head."playlistType" as "playlistType",
   head."channelID" as "channelID",
    channel."name" as "channelName"
  from "YTPlaylistHead" as head
  inner join "YTChannelInfo" as channel on head."channelID" = channel.id
  where head.id = ANY(ids)
  order by array_position(ids, head.id);
end
$$;


ALTER FUNCTION "public"."getheaddatas"("ids" character varying[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."getheads"("ids" character varying[]) RETURNS TABLE("id" character varying, "originURL" "text", "title" "text", "thumbnailURLString" "text", "insertedDate" timestamp with time zone, "isShazamed" boolean, "playlistType" "public"."YTPlaylistType", "channelID" character varying, "channelName" "text")
    LANGUAGE "plpgsql"
    AS $$
begin
  return query
  select 
    head.id as "id",
    head."originURL" as "originURL",
    head."title" as "title",
    head."thumbnailURLString" as "thumbnailURLString",
    head."insertedDate" as "insertedDate",
    head."isShazamed" as "isShazamed",
    head."playlistType" as "playlistType",
    head."channelID" as "channelID",
    channel."name" as "channelName"
  from "YTPlaylistHead" as head
  inner join "YTChannelInfo" as channel on head."channelID" = channel.id
  where head.id = ANY(ids)
  order by array_position(ids, head.id);
end
$$;


ALTER FUNCTION "public"."getheads"("ids" character varying[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."getheads2"("ids" character varying[]) RETURNS TABLE("id" character varying, "originURL" "text", "title" "text", "thumbnailURLString" "text", "insertedDate" timestamp with time zone, "isShazamed" boolean, "playlistType" "public"."YTPlaylistType", "channelID" character varying, "channelName" "text")
    LANGUAGE "plpgsql"
    AS $$
begin
  return query
  select 
    head.id as "id",
    head."originURL" as "originURL",
    head."title" as "title",
    head."thumbnailURLString" as "thumbnailURLString",
    head."insertedDate" as "insertedDate",
    head."isShazamed" as "isShazamed",
    head."playlistType" as "playlistType",
    head."channelID" as "channelID",
    channel."name" as "channelName"
  from "YTPlaylistHead" as head
  left join "YTChannelInfo" as channel on head."channelID" = channel.id
  where head.id = ANY(ids);
  -- order by array_position(ids, head.id);
end
$$;


ALTER FUNCTION "public"."getheads2"("ids" character varying[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."getmetadatas"("ids" character varying[]) RETURNS TABLE("id" character varying, "originURL" "text", "title" "text", "thumbnailURLString" "text", "insertedDate" timestamp with time zone, "isShazamed" boolean, "playlistType" "public"."YTPlaylistType", "channelID" character varying, "channelName" "text")
    LANGUAGE "plpgsql"
    AS $$
begin
  return query
  select 
    meta.id as "id",
    meta."originURL" as "originURL",
    meta."title" as "title",
    meta."thumbnailURLString" as "thumbnailURLString",
    meta."insertedDate" as "insertedDate",
    meta."isShazamed" as "isShazamed",
    meta."playlistType" as "playlistType",
    meta."channelID" as "channelID",
    channel."name" as "channelName"
  from "YTPlaylistMetaData" as meta
  inner join "YTChannelInfo" as channel on meta."channelID" = channel.id
  where meta.id = ANY(ids)
  order by array_position(ids, meta.id);
end
$$;


ALTER FUNCTION "public"."getmetadatas"("ids" character varying[]) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."gettotalplaylistcount"() RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
  begin
    RETURN (SELECT COUNT(*) FROM "YTPlaylistHead");
  end
$$;


ALTER FUNCTION "public"."gettotalplaylistcount"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."gettotalsongcount"() RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
  begin
    RETURN (SELECT COUNT(DISTINCT "ISRC") FROM "MusicInfoJoin");
  end
$$;


ALTER FUNCTION "public"."gettotalsongcount"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."headsaccessbydatedesc"("limitnumber" integer) RETURNS SETOF character varying
    LANGUAGE "plpgsql"
    AS $$
  begin
    RETURN QUERY
    select
      "YTPlaylistHead"."id" as "id"
    from
    "YTPlaylistHead"
      inner join "PlaylistHeadAccessDate" on "PlaylistHeadAccessDate".id = "YTPlaylistHead".id
      order by "PlaylistHeadAccessDate".access DESC
    LIMIT limitNumber;
  end
$$;


ALTER FUNCTION "public"."headsaccessbydatedesc"("limitnumber" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."insert_sqooped_log"("playlist_id" character varying, "now_date" timestamp with time zone, "country_code" character varying DEFAULT NULL::character varying) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
declare
    watch int;
    today_date timestamptz; -- access 변수가 필요하다면 함수의 입력으로 받거나 정의해야 함
begin
    -- 오늘 날짜의 00:00:00 설정
    today_date := date_trunc('day', now_date::timestamp);
    watch := (extract(hour from now_date::timestamp))::int / 3;

    -- "SendToPlaylistDate" 테이블에 삽입 (충돌 시 업데이트)
    insert into "SendToPlaylistDate" 
    ("id", "watchSystem", "sqooped_date", "country_code", "sqoop_count")
    values 
    (playlist_id, watch, today_date, country_code, 1)
    on conflict ("id", "watchSystem", "sqooped_date")
    do update set "sqoop_count" = excluded."sqoop_count" + 1;

    -- "RecentSqoopedPlaylists" 테이블에 삽입 (충돌 시 업데이트)
    insert into "RecentSqoopedPlaylists" ("id", "sqooped_date")
    values (playlist_id, now_date)
    on conflict ("id")
    do update set sqooped_date = now_date;
    return;
end;
$$;


ALTER FUNCTION "public"."insert_sqooped_log"("playlist_id" character varying, "now_date" timestamp with time zone, "country_code" character varying) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."maintain_latest_100_with_playlist_head_access_date"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    DELETE FROM "PlaylistHeadAccessDate"
    WHERE id NOT IN (
        SELECT id FROM (
            SELECT id FROM "PlaylistHeadAccessDate"
            ORDER BY access DESC
            LIMIT 100
        ) AS subquery
    );
    RETURN NULL; -- AFTER 트리거에서는 RETURN NULL 사용
END;
$$;


ALTER FUNCTION "public"."maintain_latest_100_with_playlist_head_access_date"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."maintain_latest_100_with_recent_sqooped_playlists"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    DELETE FROM "RecentSqoopedPlaylists"
    WHERE id NOT IN (
        SELECT id FROM (
            SELECT id FROM "RecentSqoopedPlaylists"
            ORDER BY sqooped_date DESC
            LIMIT 100
        ) AS subquery
    );
    RETURN NULL; -- AFTER 트리거에서는 RETURN NULL 사용
END;
$$;


ALTER FUNCTION "public"."maintain_latest_100_with_recent_sqooped_playlists"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."metadataaccessbydatedesc"("limitnumber" integer) RETURNS SETOF character varying
    LANGUAGE "plpgsql"
    AS $$
  begin
    RETURN QUERY
    select
      "YTPlaylistMetaData"."id" as "id"
    from
    "YTPlaylistMetaData"
      inner join "MetaDataAccessDate" on "MetaDataAccessDate".id = "YTPlaylistMetaData".id
      order by "MetaDataAccessDate".access DESC
    LIMIT limitNumber;
  end
$$;


ALTER FUNCTION "public"."metadataaccessbydatedesc"("limitnumber" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."playlistaccessbydatedesc"("limitnumber" integer) RETURNS SETOF character varying
    LANGUAGE "plpgsql"
    AS $$
  begin
    RETURN QUERY
    select
      "YTPlaylistHead"."id" as "id"
    from
    "YTPlaylistHead"
      inner join "PlaylistHeadAccessDate" on "PlaylistHeadAccessDate".id = "YTPlaylistHead".id
      order by "PlaylistHeadAccessDate".access DESC
    LIMIT limitNumber;
  end
$$;


ALTER FUNCTION "public"."playlistaccessbydatedesc"("limitnumber" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."redirect_delete_to_access"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN

    DELETE FROM "PlaylistHeadAccessDate"
    WHERE id = OLD.id;

    RETURN NULL; -- 기존 뷰에는 아무것도 삽입하지 않음
END;
$$;


ALTER FUNCTION "public"."redirect_delete_to_access"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."redirect_delete_to_head"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN

    DELETE FROM "YTPlaylistHead"
    WHERE id = OLD.id;

    RETURN NULL; -- 기존 뷰에는 아무것도 삽입하지 않음
END;
$$;


ALTER FUNCTION "public"."redirect_delete_to_head"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."redirect_insert_to_access"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- 데이터 삽입을 새 테이블로 리다이렉트
    INSERT INTO "PlaylistHeadAccessDate" (
      "id",
      "access"
    ) -- 필요한 컬럼 명시
    VALUES (
      NEW."id",
      NEW."access"
      );

    RETURN NULL; -- 기존 뷰에는 아무것도 삽입하지 않음
END;
$$;


ALTER FUNCTION "public"."redirect_insert_to_access"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."redirect_insert_to_head"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- 데이터 삽입을 새 테이블로 리다이렉트
    INSERT INTO "YTPlaylistHead" (
      "id",
      "originURL",
      "insertedDate",
      "isShazamed",
      "thumbnailURLString",
      "playlistType",
      "title",
      "channelID"
    ) -- 필요한 컬럼 명시
    VALUES (
      NEW."id",
      NEW."originURL",
      NEW."insertedDate",
      NEW."isShazamed",
      NEW."thumbnailURLString",
      NEW."playlistType",
      NEW."title",
      NEW."channelID"
      );

    RETURN NULL; -- 기존 뷰에는 아무것도 삽입하지 않음
END;
$$;


ALTER FUNCTION "public"."redirect_insert_to_head"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."redirect_update_to_access"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- 데이터 삽입을 새 테이블로 리다이렉트
    UPDATE "PlaylistHeadAccessDate" 
    set "id" = NEW."id",
    "access" = NEW."access"
    where "id" = OLD."id";

    RETURN NEW; -- 기존 뷰에는 아무것도 삽입하지 않음
END;
$$;


ALTER FUNCTION "public"."redirect_update_to_access"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."redirect_update_to_head"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    -- 데이터 삽입을 새 테이블로 리다이렉트
    UPDATE "YTPlaylistHead" 
    set "id" = NEW."id",
    "originURL" = NEW."originURL",
    "insertedDate" = NEW."insertedDate",
    "isShazamed" = NEW."isShazamed",
    "thumbnailURLString" = NEW."thumbnailURLString",
    "playlistType" = NEW."playlistType",
    "title" = NEW."title",
    "channelID" = NEW."channelID"
    where "id" = OLD."id";

    RETURN NEW; -- 기존 뷰에는 아무것도 삽입하지 않음
END;
$$;


ALTER FUNCTION "public"."redirect_update_to_head"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."PlaylistHeadAccessDate" (
    "id" character varying NOT NULL,
    "access" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."PlaylistHeadAccessDate" OWNER TO "postgres";


COMMENT ON TABLE "public"."PlaylistHeadAccessDate" IS '플리 접근한 날짜 기록';



CREATE OR REPLACE VIEW "public"."MetaDataAccessDate" AS
 SELECT "PlaylistHeadAccessDate"."id",
    "PlaylistHeadAccessDate"."access"
   FROM "public"."PlaylistHeadAccessDate";


ALTER TABLE "public"."MetaDataAccessDate" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."MusicInfoJoin" (
    "idx" smallint NOT NULL,
    "musicKey" "text" NOT NULL,
    "ISRC" character varying DEFAULT ''::character varying NOT NULL,
    "id" character varying DEFAULT ''::character varying NOT NULL,
    "musicPlatformType" "public"."MusicPlatform" NOT NULL
);


ALTER TABLE "public"."MusicInfoJoin" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."MusicStartJoin" (
    "id" character varying DEFAULT ''::character varying NOT NULL,
    "idx" smallint DEFAULT '0'::smallint NOT NULL,
    "startTime" integer DEFAULT 0 NOT NULL
);


ALTER TABLE "public"."MusicStartJoin" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."RecentSqoopedPlaylists" (
    "id" character varying NOT NULL,
    "sqooped_date" timestamp with time zone NOT NULL
);


ALTER TABLE "public"."RecentSqoopedPlaylists" OWNER TO "postgres";


COMMENT ON TABLE "public"."RecentSqoopedPlaylists" IS '가장 최근 스쿱한 플레이리스트';



CREATE TABLE IF NOT EXISTS "public"."SendToPlaylistDate" (
    "id" character varying NOT NULL,
    "sqooped_date" "date" NOT NULL,
    "watchSystem" smallint DEFAULT '0'::smallint NOT NULL,
    "country_code" character varying,
    "sqoop_count" smallint DEFAULT '0'::smallint NOT NULL
);


ALTER TABLE "public"."SendToPlaylistDate" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."Version_iOS" (
    "version" character varying NOT NULL,
    "statusCode" smallint DEFAULT '200'::smallint NOT NULL
);


ALTER TABLE "public"."Version_iOS" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."WeeklyMostSqoopedPlaylists" AS
 SELECT "s"."id",
    ("date_trunc"('week'::"text", ("s"."sqooped_date")::timestamp with time zone))::"date" AS "date",
    ("sum"("s"."sqoop_count"))::smallint AS "sqoop_count"
   FROM "public"."SendToPlaylistDate" "s"
  GROUP BY "s"."id", (("date_trunc"('week'::"text", ("s"."sqooped_date")::timestamp with time zone))::"date");


ALTER TABLE "public"."WeeklyMostSqoopedPlaylists" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."YTChannelInfo" (
    "id" character varying NOT NULL,
    "name" "text" NOT NULL,
    "thumbnailURLString" "text" DEFAULT ''::"text" NOT NULL,
    "subscribers" bigint DEFAULT '0'::bigint
);


ALTER TABLE "public"."YTChannelInfo" OWNER TO "postgres";


COMMENT ON TABLE "public"."YTChannelInfo" IS '유튜브 채널 정보';



CREATE TABLE IF NOT EXISTS "public"."YTOfficialPlaylist" (
    "id" character varying NOT NULL,
    "totalSongCount" smallint DEFAULT '0'::smallint NOT NULL,
    "musicPlatformType" "public"."MusicPlatform" NOT NULL
);


ALTER TABLE "public"."YTOfficialPlaylist" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."YTPlaylistHead" (
    "id" character varying DEFAULT ''::character varying NOT NULL,
    "originURL" "text" DEFAULT ''::"text" NOT NULL,
    "insertedDate" timestamp with time zone DEFAULT "now"() NOT NULL,
    "isShazamed" boolean NOT NULL,
    "thumbnailURLString" "text" DEFAULT ''::"text" NOT NULL,
    "playlistType" "public"."YTPlaylistType" NOT NULL,
    "title" "text" DEFAULT ''::"text" NOT NULL,
    "channelID" character varying DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "public"."YTPlaylistHead" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."YTPlaylistMetaData" AS
 SELECT "YTPlaylistHead"."id",
    "YTPlaylistHead"."originURL",
    "YTPlaylistHead"."insertedDate",
    "YTPlaylistHead"."isShazamed",
    "YTPlaylistHead"."thumbnailURLString",
    "YTPlaylistHead"."playlistType",
    "YTPlaylistHead"."title",
    "YTPlaylistHead"."channelID"
   FROM "public"."YTPlaylistHead";


ALTER TABLE "public"."YTPlaylistMetaData" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."YTVideoPlaylist" (
    "id" character varying DEFAULT ''::character varying NOT NULL,
    "playLength" integer DEFAULT 0 NOT NULL,
    "musicPlatformType" "public"."MusicPlatform" NOT NULL
);


ALTER TABLE "public"."YTVideoPlaylist" OWNER TO "postgres";


ALTER TABLE ONLY "public"."YTChannelInfo"
    ADD CONSTRAINT "ChannelInfo_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."PlaylistHeadAccessDate"
    ADD CONSTRAINT "MetaDataAccessDate_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."MusicInfoJoin"
    ADD CONSTRAINT "MusicInfoJoin_pkey" PRIMARY KEY ("musicKey", "id", "musicPlatformType");



ALTER TABLE ONLY "public"."MusicStartJoin"
    ADD CONSTRAINT "MusicStartJoin_pkey" PRIMARY KEY ("id", "idx", "startTime");



ALTER TABLE ONLY "public"."RecentSqoopedPlaylists"
    ADD CONSTRAINT "RecentSqoopedPlaylists_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."SendToPlaylistDate"
    ADD CONSTRAINT "SendToPlaylistDate_pkey" PRIMARY KEY ("id", "sqooped_date", "watchSystem");



ALTER TABLE ONLY "public"."Version_iOS"
    ADD CONSTRAINT "Version_iOS_pkey" PRIMARY KEY ("version");



ALTER TABLE ONLY "public"."YTOfficialPlaylist"
    ADD CONSTRAINT "YTOfficialPlaylistTable_pkey" PRIMARY KEY ("id", "musicPlatformType");



ALTER TABLE ONLY "public"."YTPlaylistHead"
    ADD CONSTRAINT "YTPlaylistMetaData_id_key" UNIQUE ("id");



ALTER TABLE ONLY "public"."YTPlaylistHead"
    ADD CONSTRAINT "YTPlaylistMetaData_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."YTVideoPlaylist"
    ADD CONSTRAINT "YTVideoPlaylist_pkey" PRIMARY KEY ("id", "musicPlatformType");



CREATE OR REPLACE TRIGGER "MaintainLatest100WithPlaylistHeadAccessDate" AFTER INSERT ON "public"."PlaylistHeadAccessDate" FOR EACH ROW EXECUTE FUNCTION "public"."maintain_latest_100_with_playlist_head_access_date"();



CREATE OR REPLACE TRIGGER "MaintainLatest100WithRecentSqoopedPlaylists" AFTER INSERT ON "public"."RecentSqoopedPlaylists" FOR EACH ROW EXECUTE FUNCTION "public"."maintain_latest_100_with_recent_sqooped_playlists"();



CREATE OR REPLACE TRIGGER "delete_redirect_access_trigger" INSTEAD OF DELETE ON "public"."MetaDataAccessDate" FOR EACH ROW EXECUTE FUNCTION "public"."redirect_delete_to_access"();



CREATE OR REPLACE TRIGGER "delete_redirect_meta_trigger" INSTEAD OF DELETE ON "public"."YTPlaylistMetaData" FOR EACH ROW EXECUTE FUNCTION "public"."redirect_delete_to_head"();



CREATE OR REPLACE TRIGGER "insert_redirect_access_trigger" INSTEAD OF INSERT ON "public"."MetaDataAccessDate" FOR EACH ROW EXECUTE FUNCTION "public"."redirect_insert_to_access"();



CREATE OR REPLACE TRIGGER "insert_redirect_meta_trigger" INSTEAD OF INSERT ON "public"."YTPlaylistMetaData" FOR EACH ROW EXECUTE FUNCTION "public"."redirect_insert_to_head"();



CREATE OR REPLACE TRIGGER "update_redirect_access_trigger" INSTEAD OF UPDATE ON "public"."MetaDataAccessDate" FOR EACH ROW EXECUTE FUNCTION "public"."redirect_update_to_access"();



CREATE OR REPLACE TRIGGER "update_redirect_meta_trigger" INSTEAD OF UPDATE ON "public"."YTPlaylistMetaData" FOR EACH ROW EXECUTE FUNCTION "public"."redirect_update_to_head"();





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";





GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";





















































































































































































































GRANT ALL ON FUNCTION "public"."findPlaylistMusics"() TO "anon";
GRANT ALL ON FUNCTION "public"."findPlaylistMusics"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."findPlaylistMusics"() TO "service_role";



GRANT ALL ON FUNCTION "public"."get_is_shazamed"("playlistid" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."get_is_shazamed"("playlistid" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_is_shazamed"("playlistid" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."get_weekly_most_sqooped_playlists_v1"("now_date" "date", "limit_count" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."get_weekly_most_sqooped_playlists_v1"("now_date" "date", "limit_count" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_weekly_most_sqooped_playlists_v1"("now_date" "date", "limit_count" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."getheaddatas"("ids" character varying[]) TO "anon";
GRANT ALL ON FUNCTION "public"."getheaddatas"("ids" character varying[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."getheaddatas"("ids" character varying[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."getheads"("ids" character varying[]) TO "anon";
GRANT ALL ON FUNCTION "public"."getheads"("ids" character varying[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."getheads"("ids" character varying[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."getheads2"("ids" character varying[]) TO "anon";
GRANT ALL ON FUNCTION "public"."getheads2"("ids" character varying[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."getheads2"("ids" character varying[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."getmetadatas"("ids" character varying[]) TO "anon";
GRANT ALL ON FUNCTION "public"."getmetadatas"("ids" character varying[]) TO "authenticated";
GRANT ALL ON FUNCTION "public"."getmetadatas"("ids" character varying[]) TO "service_role";



GRANT ALL ON FUNCTION "public"."gettotalplaylistcount"() TO "anon";
GRANT ALL ON FUNCTION "public"."gettotalplaylistcount"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."gettotalplaylistcount"() TO "service_role";



GRANT ALL ON FUNCTION "public"."gettotalsongcount"() TO "anon";
GRANT ALL ON FUNCTION "public"."gettotalsongcount"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."gettotalsongcount"() TO "service_role";



GRANT ALL ON FUNCTION "public"."headsaccessbydatedesc"("limitnumber" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."headsaccessbydatedesc"("limitnumber" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."headsaccessbydatedesc"("limitnumber" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."insert_sqooped_log"("playlist_id" character varying, "now_date" timestamp with time zone, "country_code" character varying) TO "anon";
GRANT ALL ON FUNCTION "public"."insert_sqooped_log"("playlist_id" character varying, "now_date" timestamp with time zone, "country_code" character varying) TO "authenticated";
GRANT ALL ON FUNCTION "public"."insert_sqooped_log"("playlist_id" character varying, "now_date" timestamp with time zone, "country_code" character varying) TO "service_role";



GRANT ALL ON FUNCTION "public"."maintain_latest_100_with_playlist_head_access_date"() TO "anon";
GRANT ALL ON FUNCTION "public"."maintain_latest_100_with_playlist_head_access_date"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."maintain_latest_100_with_playlist_head_access_date"() TO "service_role";



GRANT ALL ON FUNCTION "public"."maintain_latest_100_with_recent_sqooped_playlists"() TO "anon";
GRANT ALL ON FUNCTION "public"."maintain_latest_100_with_recent_sqooped_playlists"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."maintain_latest_100_with_recent_sqooped_playlists"() TO "service_role";



GRANT ALL ON FUNCTION "public"."metadataaccessbydatedesc"("limitnumber" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."metadataaccessbydatedesc"("limitnumber" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."metadataaccessbydatedesc"("limitnumber" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."playlistaccessbydatedesc"("limitnumber" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."playlistaccessbydatedesc"("limitnumber" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."playlistaccessbydatedesc"("limitnumber" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."redirect_delete_to_access"() TO "anon";
GRANT ALL ON FUNCTION "public"."redirect_delete_to_access"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."redirect_delete_to_access"() TO "service_role";



GRANT ALL ON FUNCTION "public"."redirect_delete_to_head"() TO "anon";
GRANT ALL ON FUNCTION "public"."redirect_delete_to_head"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."redirect_delete_to_head"() TO "service_role";



GRANT ALL ON FUNCTION "public"."redirect_insert_to_access"() TO "anon";
GRANT ALL ON FUNCTION "public"."redirect_insert_to_access"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."redirect_insert_to_access"() TO "service_role";



GRANT ALL ON FUNCTION "public"."redirect_insert_to_head"() TO "anon";
GRANT ALL ON FUNCTION "public"."redirect_insert_to_head"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."redirect_insert_to_head"() TO "service_role";



GRANT ALL ON FUNCTION "public"."redirect_update_to_access"() TO "anon";
GRANT ALL ON FUNCTION "public"."redirect_update_to_access"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."redirect_update_to_access"() TO "service_role";



GRANT ALL ON FUNCTION "public"."redirect_update_to_head"() TO "anon";
GRANT ALL ON FUNCTION "public"."redirect_update_to_head"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."redirect_update_to_head"() TO "service_role";



























GRANT ALL ON TABLE "public"."PlaylistHeadAccessDate" TO "anon";
GRANT ALL ON TABLE "public"."PlaylistHeadAccessDate" TO "authenticated";
GRANT ALL ON TABLE "public"."PlaylistHeadAccessDate" TO "service_role";



GRANT ALL ON TABLE "public"."MetaDataAccessDate" TO "anon";
GRANT ALL ON TABLE "public"."MetaDataAccessDate" TO "authenticated";
GRANT ALL ON TABLE "public"."MetaDataAccessDate" TO "service_role";



GRANT ALL ON TABLE "public"."MusicInfoJoin" TO "anon";
GRANT ALL ON TABLE "public"."MusicInfoJoin" TO "authenticated";
GRANT ALL ON TABLE "public"."MusicInfoJoin" TO "service_role";



GRANT ALL ON TABLE "public"."MusicStartJoin" TO "anon";
GRANT ALL ON TABLE "public"."MusicStartJoin" TO "authenticated";
GRANT ALL ON TABLE "public"."MusicStartJoin" TO "service_role";



GRANT ALL ON TABLE "public"."RecentSqoopedPlaylists" TO "anon";
GRANT ALL ON TABLE "public"."RecentSqoopedPlaylists" TO "authenticated";
GRANT ALL ON TABLE "public"."RecentSqoopedPlaylists" TO "service_role";



GRANT ALL ON TABLE "public"."SendToPlaylistDate" TO "anon";
GRANT ALL ON TABLE "public"."SendToPlaylistDate" TO "authenticated";
GRANT ALL ON TABLE "public"."SendToPlaylistDate" TO "service_role";



GRANT ALL ON TABLE "public"."Version_iOS" TO "anon";
GRANT ALL ON TABLE "public"."Version_iOS" TO "authenticated";
GRANT ALL ON TABLE "public"."Version_iOS" TO "service_role";



GRANT ALL ON TABLE "public"."WeeklyMostSqoopedPlaylists" TO "anon";
GRANT ALL ON TABLE "public"."WeeklyMostSqoopedPlaylists" TO "authenticated";
GRANT ALL ON TABLE "public"."WeeklyMostSqoopedPlaylists" TO "service_role";



GRANT ALL ON TABLE "public"."YTChannelInfo" TO "anon";
GRANT ALL ON TABLE "public"."YTChannelInfo" TO "authenticated";
GRANT ALL ON TABLE "public"."YTChannelInfo" TO "service_role";



GRANT ALL ON TABLE "public"."YTOfficialPlaylist" TO "anon";
GRANT ALL ON TABLE "public"."YTOfficialPlaylist" TO "authenticated";
GRANT ALL ON TABLE "public"."YTOfficialPlaylist" TO "service_role";



GRANT ALL ON TABLE "public"."YTPlaylistHead" TO "anon";
GRANT ALL ON TABLE "public"."YTPlaylistHead" TO "authenticated";
GRANT ALL ON TABLE "public"."YTPlaylistHead" TO "service_role";



GRANT ALL ON TABLE "public"."YTPlaylistMetaData" TO "anon";
GRANT ALL ON TABLE "public"."YTPlaylistMetaData" TO "authenticated";
GRANT ALL ON TABLE "public"."YTPlaylistMetaData" TO "service_role";



GRANT ALL ON TABLE "public"."YTVideoPlaylist" TO "anon";
GRANT ALL ON TABLE "public"."YTVideoPlaylist" TO "authenticated";
GRANT ALL ON TABLE "public"."YTVideoPlaylist" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
