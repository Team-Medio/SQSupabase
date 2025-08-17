set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.maintain_latest_100_with_recent_sqooped_channels()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$BEGIN
    DELETE FROM recent_sqooped_channels
    WHERE channel_id NOT IN (
        SELECT channel_id FROM (
            SELECT channel_id FROM recent_sqooped_channels
            ORDER BY sqooped_date DESC
            LIMIT 100
        ) AS subquery
    );
    RETURN NULL; -- AFTER 트리거에서는 RETURN NULL 사용
END;$function$
;

CREATE TRIGGER maintainlatest100withrecentsqoopedchannels AFTER INSERT OR UPDATE ON public.recent_sqooped_channels FOR EACH ROW EXECUTE FUNCTION maintain_latest_100_with_recent_sqooped_channels();


