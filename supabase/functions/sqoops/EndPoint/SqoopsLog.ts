import { ChartDataEntity } from "../Model/ChartDataEntity.ts";
import { ErrorResponse, SuccessResponse } from "../../common/Models/Responses.ts";
import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.54.0/src/SupabaseClient.ts";

export class SqoopsLog {
    private supabase: SupabaseClient;
    constructor(supabase: SupabaseClient) {
      this.supabase = supabase;
    }
    async action(req: Request): Promise<Response> {
      switch (req.method) {
        case "POST": {
          const json: ChartDataEntity = await req.json();
          const res = await this.supabase.rpc('insert_sqooped_log_v2', { 
            playlistid: json.id,
            nowdate: json.date,
            channelid: json.channelID,
            countrycode: json.locale
          });
          return res.error ?
            ErrorResponse(res.error.message, 500) :
            SuccessResponse(json);
        }
        default: {
          return ErrorResponse(`req.method Method error ${req.method}`, 405);
        }
      }
    }
  }