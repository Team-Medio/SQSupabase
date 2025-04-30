// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from 'jsr:@supabase/supabase-js@2'
import { ErrorResponse, SuccessResponse } from 'Responses'
import { FilterType, PeriodType, InsertValueModel_v1 } from "QueryTypes"
import { RecentQuery } from "RecentQuery"
import { MostQuery } from "./QueryMethods/MostQuery.ts"
const defaultClient = (authorization: string) => createClient( 
  Deno.env.get('SUPABASE_URL') ?? '',
   Deno.env.get('SUPABASE_ANON_KEY') ?? '',
  { global: { headers: { Authorization: authorization! } } }
)

Deno.serve(async (req: Request) => {
  // if(req.method !== "GET") return ErrorResponse("Method error", 405);
  if(Deno.env.get('SUPABASE_ANON_KEY') !== req.headers.get('Authorization')) return ErrorResponse("Authorization error", 401);
  const ActionByRequestMethods: { [key: string]: () => Promise<Response> } = {
    "GET": async ()=>{
      try {
        const supabase = defaultClient(req.headers.get('Authorization')!);
        const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
        const filterType : FilterType = params.get("filter") as FilterType ?? "";
        const limitCount: number = Number(params.get("limitcount")) ?? 0;
          switch(filterType){
            case FilterType.RECENT: {
              const { data, error } = await RecentQuery.PlaylistHeadAccessDateVersion(supabase, limitCount);
              return error ? ErrorResponse(error.message, 500) : SuccessResponse(data?.map((x: { id: string }) => x.id) ?? []);
            }
            case FilterType.MOST: {
              const periodType: PeriodType = params.get("period") as PeriodType ?? "";
              const date:Date = new Date(params.get("date") as string);
              const {data, error} = await MostQuery.v1(supabase, periodType, date, limitCount);
              return error ? ErrorResponse(error.message, 500) : SuccessResponse(data);
            }
            default: return ErrorResponse("FilterTypeError", 401);
          }
      } catch (err) {
        return new Response(String(err?.message ?? err), { status: 500 })
      }
    },
    "POST": async ()=>{
      try {
        const supabase = defaultClient(req.headers.get('Authorization')!);
        const json: InsertValueModel_v1 = await req.json();
        
        const res = await supabase.rpc('insert_sqooped_log', { 
            playlist_id: json.id,
            now_date: json.date,
            country_code: json.locale
          });
        return res.error ?
          ErrorResponse(res.error.message, 500) :
          SuccessResponse(json);
      }catch(err){
        return new Response(String(err?.message ?? err), { status: 500 })
      }
    }
  };
  return ActionByRequestMethods[req.method] ? 
    await ActionByRequestMethods[req.method]() : 
    ErrorResponse("Method error", 405);
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/PlaylistIDs' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
