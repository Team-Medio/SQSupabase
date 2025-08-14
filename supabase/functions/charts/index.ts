// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.54.0/src/SupabaseClient.ts";
import { ErrorResponse } from "../common/Models/Responses.ts";
import { defaultClient } from "../common/Helpers/defaultClient.ts";
import { checkAuthorization } from "../common/Helpers/checkAuthorization.ts";
import { ChartsPlaylists } from "./EndPoint/ChartPlaylists.ts";
import { ChartsChannels } from "./EndPoint/ChartChannels.ts";

Deno.serve(async (req) => {
  const error = checkAuthorization(req);
  if(error) return error;
  const supabase: SupabaseClient = defaultClient(req.headers.get('Authorization')!);
  const url: URL = new URL(req.url);
  const pathname = url.pathname.split("charts")[1];
  if(pathname.startsWith("/playlists")){
    const playlists = new ChartsPlaylists(supabase);
    return await playlists.action(req);
  } else if (pathname.startsWith("/channels")) {
    const channels = new ChartsChannels(supabase);
    return await channels.action(req);
  }
  return ErrorResponse(`urlPath Error ${url.pathname}`, 405);
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/charts' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
