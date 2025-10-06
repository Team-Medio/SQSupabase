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
          const json = await req.json();
          const entity: ChartDataEntity = {
            id: json.id,
            date: new Date(json.date),
            locale: json.locale,
            channelID: json.channelID
          }
          const res = await this.supabase.rpc('insert_sqooped_log_v2', { 
            playlistid: entity.id,
            nowdate: entity.date,
            channelid: entity.channelID,
            countrycode: entity.locale
          });
          return res.error ?
            ErrorResponse(res.error.message, 500) :
            SuccessResponse(entity);
        }
        default: {
          return ErrorResponse(`req.method Method error ${req.method}`, 405);
        }
      }
    }
  }