import { ErrorResponse } from "../Models/Responses.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

export const checkAuthorization = (req: Request): Response | undefined => {
    const authHeader = req.headers.get('Authorization');
    const authAnonKey = authHeader?.startsWith('Bearer ') ? authHeader.split(' ')[1] : authHeader;  
    if(Deno.env.get('SUPABASE_ANON_KEY') !== authAnonKey) {
    return ErrorResponse(`Authorization error`, 401);
  }
  return undefined;
}