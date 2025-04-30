import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.48.1/src/SupabaseClient.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { PeriodType, MostSqoopedModel_v1 } from "QueryTypes";



export const MostQuery = {
    // 쿼리문: 전체 결과 -> 같은 날짜, 스쿱 개수로 정렬, limit 개수만큼 반환
    v1: async (supabase: SupabaseClient,
        periodType: PeriodType,
        date: Date,
        limit: number) => {
        const periodMostTable = {
            [PeriodType.WEEK]: "get_weekly_most_sqooped_playlists_v1",
            [PeriodType.MONTH]: "MonthlyMostSqoopedPlaylists",
        };
        const tableName: string = periodMostTable[periodType] ?? "";
        return await supabase.rpc(tableName, {
             now_date: date.toDateString(), 
             limit_count: limit 
            });
    }
};