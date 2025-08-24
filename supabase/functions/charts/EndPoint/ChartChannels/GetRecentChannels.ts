import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.54.0/src/SupabaseClient.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { ErrorResponse, SuccessResponse } from "../../../common/Models/Responses.ts";
import { FilterType } from "../../Models/FilterType.ts";
import { PeriodType } from "../../Models/PeriodType.ts";
import { MostChannelsQuery } from "../../Queries/MostChannelsQuery.ts";
import { ChartChannelsMost } from "./GetMostChannels.ts";
import { YTChannelInfo } from "../../../common/Models/YTChannelInfo.ts";
import { ChannelHelper } from "../../../common/Helpers/ChannelHelper.ts";


/**
 * 개별 채널의 기본 정보를 담는 데이터 구조
 * 채널 ID와 채널명을 포함
 */
type RecentChannelInfo = {
  channel_id: string;
  channel_name: string;
}

/**
 * 개별 채널 정보 조회 결과를 담는 데이터 구조
 * 성공 시 채널 정보를, 실패 시 실패한 채널 ID를 포함
 */
type RecentChannelInfoResult = {
  success: RecentChannelInfo | null;
  failed: string | null;
}

export class ChartChannelsRecent {
    private supabase: SupabaseClient;
    constructor(supabase: SupabaseClient) {
      this.supabase = supabase;
    }
    
    async action(req: Request): Promise<Response> {
      switch(req.method){
        case "GET": { return await this.getChannels(req); }
        default: {
          return ErrorResponse(`Method Error ${req.method}`, 405);
        }
      }
    }

    private async getChannels(req: Request): Promise<Response> {
      try {
        const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
        const limitCount: number = Number(params.get("limitcount")) ?? 10;
        const { data, error } = await this.supabase.from('recent_sqooped_channels')
        .select()
        .order('sqooped_date', { ascending: false })
        .limit(limitCount);
        if(error) return ErrorResponse(error.message, 500);
        const channelIds = (data ?? []).map((x: { channel_id: string }) => x.channel_id);
        const channelRecentResponse = await this.getRecentChannelInfos(channelIds);
        return SuccessResponse(channelRecentResponse);
      } catch (err) {
        const errorMessage = err instanceof Error ? err.message : String(err);
        return new Response(errorMessage, { status: 500 })
      }
    }

    private async getRecentChannelInfos(channelIds: string[]): Promise<RecentChannelInfoResult[]> {
      const channelResults: RecentChannelInfoResult[]  = await Promise.all(channelIds.map(async (channelId) => {
        const { data: channelInfo, error: channelHeadError } = await this.supabase.from('YTChannelInfo').select('*').eq('id', channelId).single();
        if(channelHeadError) {
          return { success: null, failed: channelId };
        }
        let headTable = channelInfo as YTChannelInfo;
        if(headTable.thumbnailURLString === null || headTable.thumbnailURLString === "") {
          try {
            headTable = await ChannelHelper.upsertEmptyThumbnailChannel(this.supabase, headTable);
          } catch (err) {
            return { 
              success: {
                channel_id: headTable.id,
                channel_name: headTable.name,
                channel_thumbnail: headTable.thumbnailURLString,
                sqoop_count: 0
            }, 
            failed: null 
            };
          }
        }
        const channelResponse = {
          channel_id: headTable.id,
          channel_name: headTable.name,
          channel_thumbnail: headTable.thumbnailURLString
        }

        return {
          success: channelResponse,
          failed: null
        }
      }));
      
      return channelResults; 
    }
  }