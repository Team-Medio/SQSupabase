import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.54.0/src/SupabaseClient.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { ErrorResponse, SuccessResponse } from "../../common/Models/Responses.ts";
import { FilterType } from "../Models/FilterType.ts";
import { PeriodType } from "../Models/PeriodType.ts";
import { MostPlaylistsQuery } from "../Queries/MostPlaylistsQuery.ts";

export class ChartsPlaylists {
    private supabase: SupabaseClient;
    constructor(supabase: SupabaseClient) {
      this.supabase = supabase;
    }
  
    async action(req: Request): Promise<Response> {
      switch(req.method){
        case "GET": { return await this.getPlaylists(req); }
        default: {
          return ErrorResponse(`Method Error ${req.method}`, 405);
        }
      }
    }
  
    private async getPlaylists(req: Request): Promise<Response> {
      try {
        const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
        const filterType : FilterType = params.get("filter") as FilterType ?? "";
        const limitCount: number = Number(params.get("limitcount")) ?? 10;
        switch(filterType){
          case FilterType.RECENT: {
          const { data, error } = await this.supabase.from('RecentSqoopedPlaylists')
          .select('id')
          .order('sqooped_date', { ascending: false })
          .limit(limitCount);
          if (error) return ErrorResponse(error.message, 500);
          const rows = Array.isArray(data) ? data : [];
          return SuccessResponse(rows.map((x: { id: string }) => x.id));
        }
        case FilterType.MOST: {
          const periodType: PeriodType | null = params.get("period") as PeriodType | null;
          if(periodType === null) return ErrorResponse(`잘못된 period 파라미터`, 400);
          const date: Date = new Date(params.get("date") as string);
          const {data, error} = await MostPlaylistsQuery.v1(this.supabase, periodType, date, limitCount);
          return error ? ErrorResponse(error.message, 500) : SuccessResponse(data);
        }
        default: {
          return ErrorResponse(`잘못된 period 파라미터 ${filterType}`, 400);
        }
      }
      } catch (err) {
        const message = err instanceof Error ? err.message : JSON.stringify(err);
        return ErrorResponse(message, 500);
      }
    }
  }