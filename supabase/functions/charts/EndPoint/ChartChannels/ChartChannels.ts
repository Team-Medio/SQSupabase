
import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.54.0/src/SupabaseClient.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { ErrorResponse, SuccessResponse } from "../../../common/Models/Responses.ts";
import { FilterType } from "../../Models/FilterType.ts";
import { ChartChannelsMost } from "./GetMostChannels.ts";
import { ChartChannelsRecent } from "./GetRecentChannels.ts";

export class ChartsChannels {
    private supabase: SupabaseClient;
    private chartChannelsMost: ChartChannelsMost;
    private chartChannelsRecent: ChartChannelsRecent;
    constructor(supabase: SupabaseClient) {
      this.supabase = supabase;
      this.chartChannelsMost = new ChartChannelsMost(supabase);
      this.chartChannelsRecent = new ChartChannelsRecent(supabase);
    }
  
    async action(req: Request): Promise<Response> {
      return await this.getChannels(req);
    }
  
    private async getChannels(req: Request): Promise<Response> {
      try {
        const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
        const filterType : FilterType = params.get("filter") as FilterType ?? "";
        switch(filterType) {
          case FilterType.RECENT: {
          return await this.chartChannelsRecent.action(req);
        }
        case FilterType.MOST: {
          return await this.chartChannelsMost.action(req);
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


