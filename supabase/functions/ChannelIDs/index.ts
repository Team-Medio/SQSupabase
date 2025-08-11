// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from 'jsr:@supabase/supabase-js@2'
import { Chart } from "./EndPoint/Chart.ts";

const defaultClient = (authorization: string) => {
  const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? "";
  const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY') ?? "";
  
  return createClient(supabaseUrl, supabaseKey, { 
    global: { headers: { Authorization: authorization! } } 
  });
};

Deno.serve(async (req) => {

  const authHeader = req.headers.get('Authorization');
  const authAnonKey = authHeader?.startsWith('Bearer ') ? authHeader.split(' ')[1] : authHeader;
  if(Deno.env.get('SUPABASE_ANON_KEY') !== authAnonKey) {
    return ErrorResponse(`DenoValue: ${Deno.env.get('SUPABASE_ANON_KEY')}\n reqValue: ${req.headers.get('Authorization')?.split(' ')[1]}\n Authorization error`, 401);
  }

  const url = new URL(req.url);

  const client = defaultClient(req.headers.get('Authorization')!);
  if (url.pathname.includes("/chart")) {
    const chart = new Chart(client);
    return chart.action(req);
  } else if (url.pathname.includes("/relatedPlaylists")) {
    switch (req.method) {
      case "GET":
        return new Response("chart GET 요청", { 
          status: 200 
        });
      case "POST":
        return new Response("chart POST 요청", { 
          status: 200 
        });
      default:
        return new Response("Method error", { 
          status: 405 
        });
    }
  } else {
    return new Response("반가워요 기본값", { 
      status: 200 
    });
  }
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/ChannelIDs' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
