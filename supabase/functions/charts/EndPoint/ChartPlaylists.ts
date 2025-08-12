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
          .select()
          .order('sqooped_date', { ascending: false })
          .limit(limitCount);
          return error ? ErrorResponse(error.message, 500) : SuccessResponse(data?.map((x: { id: string }) => x.id) ?? []);
        }
        case FilterType.MOST: {
          const periodType: PeriodType = params.get("period") as PeriodType ?? "";
          const date: Date = new Date(params.get("date") as string);
          const {data, error} = await MostPlaylistsQuery.v1(this.supabase, periodType, date, limitCount);
          return error ? ErrorResponse(error.message, 500) : SuccessResponse(data);
        }
        default: {
          return ErrorResponse(`FilterTypeError ${filterType}`, 401);
        }
      }
      } catch (err) {
        return new Response(String(err?.message ?? err), { status: 500 })
      }
    }
  }