import { version } from "https://jsr.io/@supabase/supabase-js/2.48.1/src/lib/version.ts";
import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.48.1/src/SupabaseClient.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts"


export const VersionQueryMethods = {
    "ios": async (supabase: SupabaseClient, version: string) => {
        const { data, error } = await supabase.from('Version_iOS')
        .select('*').eq('version', version).maybeSingle();
        const statusCode = (data["statusCode"] === null) ? 200 : data["statusCode"];
        return { statusCode, error};
    }
};