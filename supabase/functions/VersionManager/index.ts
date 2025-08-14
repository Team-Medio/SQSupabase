// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from 'jsr:@supabase/supabase-js@2'
import { ErrorResponse, SuccessResponse } from 'Responses'
import { VersionQueryMethods } from "VersionManager"

const defaultClient = (authorization: string) => createClient(
  Deno.env.get('SUPABASE_URL') ?? '',
  Deno.env.get('SUPABASE_ANON_KEY') ?? '',
  { global: { headers: { Authorization: authorization! } } }
)

Deno.serve(async (req: Request) => {
  
  const authHeader = req.headers.get('Authorization');
  const authAnonKey = authHeader?.startsWith('Bearer ') ? authHeader.split(' ')[1] : authHeader;  
  if(Deno.env.get('SUPABASE_ANON_KEY') !== authAnonKey) {
    return ErrorResponse(`Authorization error`, 401);
  }

  if(req.method !== "GET") return ErrorResponse("Method error", 405);
  try {
    const supabase = defaultClient(req.headers.get('Authorization')!);
    const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
    const os = params.get("os") as string;
    const version = params.get("version") as string;
    // const { statusCode,error } = VersionQueryMethods[os](supabase, version);
    const { data, error } = await supabase.from('Version_iOS')
    .select('*').eq('version', version);
    const statusCode = data.length === 0 ? 200 : data[0]["statusCode"];
    return error ? ErrorResponse(error.message, 500) : SuccessResponse(statusCode);
  } catch (err) {
    return new Response(String(err?.message ?? err), { status: 500 });
  }
})

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/VersionManager' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
