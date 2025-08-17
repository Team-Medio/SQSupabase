import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.54.0/src/SupabaseClient.ts";
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { ErrorResponse, SuccessResponse } from "../../common/Models/Responses.ts";
import { YTChannelInfo } from "../Models/YTChannelInfo.ts";
import { YTPlaylistHead } from "../Models/YTPlaylistHead.ts";
import { YTPlaylistHeadTable } from "../Models/YTPlaylistHeadTable.ts";

// Supabase YTPlaylistHead 플레이리스트 조회 결과 타입
// 조회 성공시 타입 변환 후 반환
// 조회 실패시 실패한 ID 반환
type RequestPlaylistHeadResult = {
    playlistHead: YTPlaylistHead | null;
    failedID: string | null;
}

export class ChannelsPlaylist {
    private supabase: SupabaseClient;
    constructor(supabase: SupabaseClient) {
        this.supabase = supabase;
    }

    async action(req: Request): Promise<Response> {
        if(req.url.includes("/playlists/id")) {
            switch(req.method){
                case "GET": {
                    return await this.getPlaylistIDs(req);
                }
                default: {
                    return ErrorResponse(`req.method Error ${req.url}`, 405);
                }
            }
        } else {
            switch(req.method){
                case "GET": {
                return await this.getPlaylists(req);
                }
                default: {
                    return ErrorResponse(`req.method Error ${req.url}`, 405);
                }
            }
        }
    }   

    // 채널이 갖고 있는 플레이리스트 조회
    private async getPlaylists(req: Request): Promise<Response> {
        const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
        const channelId: string = params.get("channelId") as string;
        const limitCount: number = parseInt(params.get("limitcount") as string) ?? 10;
        try {
            const playlistIds: string[] = await this.getRPCPlaylistIDs(channelId, limitCount);

            const {data: channelData, error: channelError} = await this.supabase.from('YTChannelInfo').select('*').eq('id', channelId).single();
            if(channelError) throw new Error("Don't exist channel");
            const channelTable = channelData as YTChannelInfo;
        
            const playlistResults: RequestPlaylistHeadResult[]  = await Promise.all(playlistIds.map(async (playlistId) => {
                const { data: playlistHeadData, error: playlistHeadError } = await this.supabase.from('YTPlaylistHead').select('*').eq('id', playlistId).single();
                if(playlistHeadError) {
                    return { playlistHead: null, failedID: playlistId };
                }
                const headTable = playlistHeadData as YTPlaylistHeadTable;
                const playlistHead: YTPlaylistHead = {
                    id: headTable.id,
                    originURL: headTable.originURL,
                    insertedDate: headTable.insertedDate,
                    isShazamed: headTable.isShazamed,
                    thumbnailURL: headTable.thumbnailURLString,
                    title: headTable.title,
                    channel: channelTable,
                    ytPlaylistType: headTable.playlistType
                }
                return { playlistHead: playlistHead, failedID: null };
            }));
    
            const failedIds = playlistResults.filter(result => result.failedID !== null).map(result => result.failedID);
            const playlistHeads = playlistResults.filter(result => result.playlistHead !== null).map(result => result.playlistHead);
            const successResponse = {
                PlaylistHeads: playlistHeads,
                FailedPlaylistIDs: failedIds
            };
            return SuccessResponse(successResponse);
        } catch (error) {
            return ErrorResponse("Don't exsit playlist", 404);
        }
    }

    private async getPlaylistIDs(req: Request): Promise<Response> {
        const params: URLSearchParams = new URLSearchParams(new URL(req.url).search);
        const channelId: string = params.get("channelId") as string;
        const limitCount: number = parseInt(params.get("limitcount") as string) ?? 10;
        try {
            const playlistIds: string[] = await this.getRPCPlaylistIDs(channelId, limitCount);
            return SuccessResponse(playlistIds);
        } catch (error) {
            return ErrorResponse("Don't exsit playlist", 404);
        }
    }

    private async getRPCPlaylistIDs(channelId: string, limitCount: number): Promise<string[]> {
        const { data: playlistIdsData, error: playlistIdsError } = await this.supabase.rpc('getchannelplaylistids', {
            channelid: channelId,
            limit_count: limitCount
        });
        if(playlistIdsError)  throw new Error("Don't exsit playlist");
        const playlistIds: string[] = playlistIdsData as string[];
        return playlistIds;
    }
}

