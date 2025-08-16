import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.54.0/src/SupabaseClient.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { ErrorResponse, SuccessResponse } from "../../../common/Models/Responses.ts";
import { PeriodType } from "../../Models/PeriodType.ts";
import { MostChannelsQuery } from "../../Queries/MostChannelsQuery.ts";
import { YTChannelInfo } from "../../../common/Models/YTChannelInfo.ts";

/**
 * 차트에서 가장 많이 sqoop된 채널들의 응답 데이터
 * 성공한 채널 정보들과 실패한 채널 ID들을 포함
 */
type ChannelsWithFailures = {
    MostChannelResponses: ChannelWithSqoopCount[];
    FailedChannelIds: string[];
};
  
// 데이터베이스 쿼리 결과로 반환되는 채널별 sqoop 카운트 데이터
type ChannelSqoopCountData = {
    channel_id: string;
    sqoop_count: number;
};

// 채널 정보와 sqoop 카운트를 포함한 완전한 채널 데이터
type ChannelWithSqoopCount = {
    channel_id: string;
    channel_name: string;
    sqoop_count: number;
};
  
/**
 * 개별 채널 정보 조회 결과
 * 성공 시 채널 정보를, 실패 시 실패한 채널 ID를 반환
 */
type ChannelInfoResult = {
    MostChannelResponse: ChannelWithSqoopCount | null;
    FailedChannelId: string | null;
};

export class ChartChannelsMost {
    private supabase: SupabaseClient;
    
    constructor(supabase: SupabaseClient) {
      this.supabase = supabase;
    }
    
    /**
     * HTTP 요청을 처리하는 메인 액션 메서드
     * @param req HTTP 요청 객체
     * @returns HTTP 응답
     */
    async action(req: Request): Promise<Response> {
      switch(req.method){
        case "GET": { return await this.getChannels(req); }
        default: {
          return ErrorResponse(`Method Error ${req.method}`, 405);
        }
      }
    }

    /**
     * GET 요청을 통해 가장 많이 sqoop된 채널들을 조회
     * @param req HTTP GET 요청
     * @returns 채널 정보와 sqoop 카운트가 포함된 응답
     */
    private async getChannels(req: Request): Promise<Response> {
      try {
        // URL 파라미터에서 조회 조건 추출
        const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
        const periodType: PeriodType = params.get("period") as PeriodType ?? "";
        const date: Date = new Date(params.get("date") as string);
        const limitCount: number = Number(params.get("limitcount")) ?? 10;
        
        // 데이터베이스에서 sqoop 카운트 기준으로 채널 조회
        const {data, error} = await MostChannelsQuery.v1(this.supabase, periodType, date, limitCount);
        if(error) return ErrorResponse(error.message, 500);
        
        const responses: ChannelSqoopCountData[] = Array.isArray(data) ? data : [];
        const channelMostResponse = await this.getMostChannelInfos(responses);
        return SuccessResponse(channelMostResponse);
      } catch (err) {
        return new Response(String(err?.message ?? err), { status: 500 })
      }
    }

    /**
     * 채널 ID와 sqoop 카운트 데이터를 받아서 완전한 채널 정보로 변환
     * @param responses 채널 ID와 sqoop 카운트가 포함된 데이터 배열
     * @returns 성공한 채널 정보들과 실패한 채널 ID들을 포함한 응답
     */
    private async getMostChannelInfos(responses: ChannelSqoopCountData[]): Promise<ChannelsWithFailures> {
      // 각 채널 ID에 대해 병렬로 채널 정보 조회
      const channelResults: ChannelInfoResult[]  = await Promise.all(responses.map(async (response) => {
        const { data: channelInfo, error: channelHeadError } = await this.supabase.from('YTChannelInfo').select('*').eq('id', response.channel_id).single();
        if(channelHeadError) {
            return { MostChannelResponse: null, FailedChannelId: response.channel_id };
        }
        const headTable = channelInfo as YTChannelInfo;
        const channelResponse: ChannelWithSqoopCount = {
          channel_id: headTable.id,
          channel_name: headTable.name,
          sqoop_count: response.sqoop_count
        }
        return {
          MostChannelResponse: channelResponse,
          FailedChannelId: null
        }
    }));
    
    // 성공한 채널들과 실패한 채널 ID들을 분리
    const failedIds = channelResults.filter(result => result.FailedChannelId !== null).map(result => result.FailedChannelId as string);
    const channelResponses = channelResults.filter(result => result.MostChannelResponse !== null).map(result => result.MostChannelResponse as ChannelWithSqoopCount);
    
    const successResponse: ChannelsWithFailures = {
      MostChannelResponses: channelResponses ?? [],
      FailedChannelIds: failedIds ?? []
    }
    return successResponse; 
    }
  }