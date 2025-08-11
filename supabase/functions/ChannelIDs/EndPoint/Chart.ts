import { SupabaseClient } from "@supabase/supabase-js";
import { FilterType, PeriodType } from "../Model/QueryTypes.ts";
import { ErrorResponse } from "../Model/ErrorResponse.ts";

export class Chart { 
    private supabase: SupabaseClient;
    constructor(supabase: SupabaseClient) {
        this.supabase = supabase;
    }

    async action(req: Request): Promise<Response> {
        const url = new URL(req.url);
        switch (req.method) {
            case "GET":
                return this.getChart(req);
            case "POST":
                return this.postChartData(req);
            default:
                return new Response("Method error", { status: 405 });
        }
    }

    private async getChart(req: Request) {
        const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
        const filterType : FilterType = params.get("filter") as FilterType ?? "";
        const channelId = params.get("channelId");
        const limit = params.get("limit") ?? 10;
        switch(filterType) {
            case FilterType.RECENT: {
                const { data, error } = await this.supabase.from("RecentSqoopedChannels")
                .select()
                .order('sqooped_date', { ascending: false })
                .limit(limit)
                return data;
            }
            case FilterType.MOST: {
                const periodType: PeriodType = params.get("period") as PeriodType ?? "";

                const periodMostTable = {
                    [PeriodType.WEEK]: "get_weekly_most_sqooped_channels_v1",
                    [PeriodType.MONTH]: "MonthlyMostSqoopedPlaylists",
                };

                const { data, error } = await this.supabase.rpc(periodMostTable[periodType], {
                    now_date: date.toDateString(), 
                    limit_count: limit 
                });

                return data;
            }
            default: {
                return ErrorResponse("FilterTypeError", 401);
            }
        }
    }

    private async postChartData(req: Request) {
        const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
        const json: InsertValueModel_v1 = await req.json();
        const { data, error } = await this.supabase.from("ChannelIDs").insert({ id: channelId });
        return data;
    }
};

