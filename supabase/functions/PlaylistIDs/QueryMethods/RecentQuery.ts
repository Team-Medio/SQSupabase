import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.48.1/src/SupabaseClient.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

const LegacyVersion = async (supabase :SupabaseClient,limit: number) => await supabase.from('PlaylistHeadAccessDate')
    .select()
    .order('access', { ascending: false })
    .limit(limit)

const RecentVersion = async (supabase: SupabaseClient,limit: number) => await supabase.from('RecentSqoopedPlaylists')
    .select()
    .order('sqooped_date', { ascending: false })
    .limit(limit)
    
export const RecentQuery = {
    PlaylistHeadAccessDateVersion: LegacyVersion,
    RecentSqoopedPlaylistsVersion: RecentVersion
}