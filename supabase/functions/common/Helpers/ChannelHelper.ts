import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.54.0/src/SupabaseClient.ts";
import { YTChannelInfo } from "../Models/YTChannelInfo.ts";

export class ChannelHelper {
    /**
     * 썸네일이 없는 채널의 썸네일을 YouTube API에서 가져와서 업데이트
     * @param supabase Supabase 클라이언트
     * @param headTable 업데이트할 채널 정보
     * @returns 업데이트된 채널 정보
     */
    static async upsertEmptyThumbnailChannel(supabase: SupabaseClient, headTable: YTChannelInfo): Promise<YTChannelInfo> {
        const apiKey = Deno.env.get("YOUTUBE_API_KEY");
        const youtubeResponse = await fetch(
            `https://www.googleapis.com/youtube/v3/channels?part=snippet&id=${headTable.id}&key=${apiKey}`
        );
        const youtubeData = await youtubeResponse.json();

        if (youtubeData.items && youtubeData.items.length > 0) {
            const thumbnailURL = youtubeData.items[0].snippet.thumbnails?.default?.url;
            if (thumbnailURL) {
                await supabase
                    .from('YTChannelInfo')
                    .update({ thumbnailURLString: thumbnailURL })
                    .eq('id', headTable.id);
                headTable.thumbnailURLString = thumbnailURL;
            }
        } else {
            throw new Error("YouTube API 응답이 없습니다. 채널 ID: " + headTable.id);
        }
        return headTable;
    }
}
