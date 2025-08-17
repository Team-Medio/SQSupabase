import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.54.0/src/SupabaseClient.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { ErrorResponse, SuccessResponse } from "../../common/Models/Responses.ts";
import { FilterType } from "../Models/FilterType.ts";
import { PeriodType } from "../Models/PeriodType.ts";
import { MostPlaylistsQuery } from "../Queries/MostPlaylistsQuery.ts";
import { YTPlaylistHead } from "../../common/Models/YTPlaylistHead.ts";

type RequestPlaylistHeadResult = {
  playlistHead: YTPlaylistHead | null;
  failedID: string | null;
}

type PlaylistHeadsResponse = {
  PlaylistHeads: YTPlaylistHead[];
  FailedPlaylistIDs: string[];
}

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
          const { data, error } = await this.supabase.from('recent_sqooped_playlists')
          .select('id')
          .order('sqooped_date', { ascending: false })
          .limit(limitCount);
          if (error) return ErrorResponse(error.message, 500);

          const rows = Array.isArray(data) ? data : [];
          const playlistIds = rows.map((x: { id: string }) => x.id);
          const playlistHeads = await this.getPlaylistHeads(playlistIds);
          return SuccessResponse(playlistHeads);
        }
        case FilterType.MOST: {
          const periodType: PeriodType | null = params.get("period") as PeriodType | null;
          if(periodType === null) return ErrorResponse(`잘못된 period 파라미터`, 400);
          const date: Date = new Date(params.get("date") as string);
          const {data, error} = await MostPlaylistsQuery.v1(this.supabase, periodType, date, limitCount);
          if(error) return ErrorResponse(error.message, 500);

          const playlistIds: string[] = Array.isArray(data) ? data : [];
          const playlistHeads: PlaylistHeadsResponse = await this.getPlaylistHeads(playlistIds);
          return SuccessResponse(playlistHeads);
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

    private async getPlaylistHeads(playlistIds: string[]): Promise<PlaylistHeadsResponse> {
      
      const playlistResults: RequestPlaylistHeadResult[]  = await Promise.all(
        playlistIds.map( async (playlistId) => {
          const { data: playlistHeadData, error: playlistHeadError } = await this.supabase.from('YTPlaylistHead').select('*').eq('id', playlistId).single();
          if(playlistHeadError) {
            return { playlistHead: null, failedID: playlistId };
          }
          const headTable = playlistHeadData as YTPlaylistHead;
          return { playlistHead: headTable, failedID: null };
        })
      );
      const failedIds = playlistResults.filter(result => result.failedID !== null).map(result => result.failedID as string);
      const playlistHeads = playlistResults.filter(result => result.playlistHead !== null).map(result => result.playlistHead as YTPlaylistHead);
      const successResponse: PlaylistHeadsResponse = {
        PlaylistHeads: playlistHeads ?? [],
        FailedPlaylistIDs: failedIds ?? []  
      };
      return successResponse;
    }
  }
