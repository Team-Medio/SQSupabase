import * as dotenv from 'dotenv'
import { createClient, SupabaseClient } from '@supabase/supabase-js'
import { YTPlaylistHeadTable } from './Model/DBTables/YTPlaylistHeadTable';
import { YTPlaylistDTO, YTPlaylistHeadDTO, YTChannelInfoDTO, YTPlaylistBodyDTO, YTPlaylistTypeDTO, MusicPlatformTypeDTO, MusicInfoTableDTO } from './Model/PublicDTOs';
import { MusicInfoJoinTable } from './Model/DBTables/MusicInfoJoinTable';
import { YTOfficialPlaylistTable } from './Model/DBTables/YTOfficialPlaylistTable';
import { MusicStartJoinTable } from './Model/DBTables/MusicStartJoinTable';
import { YTVideoPlaylistTable } from './Model/DBTables/YTVideoPlaylistTable';


class PlaylistCachier {
    private clientURL: string;
    private clientKey: string;
    private client: SupabaseClient;

    constructor(clientURL: string, clientKey: string) {
        this.clientURL = clientURL;
        this.clientKey = clientKey;
        this.client = createClient(clientURL, clientKey);
        
        console.log("--- 생성된 클라이언트 객체 확인 ---");
        if (this.client && typeof this.client.from === 'function') {
            console.log("✅ 성공: Supabase 클라이언트 객체가 올바르게 생성되었습니다.");
            console.log("   - 'from' 메소드가 존재합니다.");
        } else {
            console.error("❌ 실패: Supabase 클라이언트 객체가 생성되지 않았거나, 손상되었습니다!");
        }
        console.log("---------------------------------");
    }


    async upsertPlaylist(data: YTPlaylistDTO) {
        const head: YTPlaylistHeadDTO = data.head;
        const headDataTable: YTPlaylistHeadTable = YTPlaylistHeadTable.fromYTPlaylistHeadDTO(head);
        const channelInfo: YTChannelInfoDTO = head.channel;

        if (headDataTable.isShazamed) {
        }
        // const { recentData, error } = await this.client.from('RecentSqoopedPlaylists').select()
        // console.log("data: ", recentData);
        // console.log("error: ", error);
        // 1. YTPlaylistHead 나중에 삽입
        const { error: headError } = await this.client.from('YTPlaylistHead').upsert(headDataTable.toJSON()).select();
        if (headError) throw new Error(`YTPlaylistHead Upsert 실패: ${JSON.stringify(headError)}`);

        // 2. YTChannelInfo 먼저 삽입 (DTO는 이미 toJSON을 가지고 있음)
        const { error: channelError } = await this.client.from('YTChannelInfo').upsert(channelInfo.toJSON()).select();
        if (channelError) throw new Error(`YTChannelInfo Upsert 실패: ${channelError.message}`);
    }

    private async insertPlaylistData(metaDataID: string, playlistData: YTPlaylistBodyDTO) {
        const musicInfoJoinTable: MusicInfoJoinTable[] = playlistData.musicInfos.map((value,index) => 
            new MusicInfoJoinTable(
                metaDataID,
                playlistData.musicPlatform,
                value.platformKey,
                index,
                value.isrc
            )
        )
        const totalInfo = playlistData.totalInfo.value

        switch (playlistData.ytPlaylistType) {
            case YTPlaylistTypeDTO.OFFICIAL:
                const officialPlaylist = new YTOfficialPlaylistTable(
                    metaDataID,
                    totalInfo,
                    playlistData.musicPlatform
                )
                await this.client.from('YTOfficialPlaylist').upsert(officialPlaylist).select();
                await this.client.from("MusicInfoJoin").upsert(musicInfoJoinTable).select();
                break;
            case YTPlaylistTypeDTO.VIDEO:
                const musicStartJoinList: MusicStartJoinTable[] = playlistData.startTimes!.map((value,index) => 
                    new MusicStartJoinTable(
                        metaDataID,
                        index,
                        value
                    )
                );
                const ytVideoPlaylist = new YTVideoPlaylistTable(
                    metaDataID,
                    totalInfo,
                    playlistData.musicPlatform
                )

                const { error: videoError } = await this.client.from('YTVideoPlaylist').upsert(ytVideoPlaylist.toJSON()).select();
                if (videoError) throw new Error(`YTVideoPlaylist Upsert 실패: ${videoError.message}`);

                // 배열은 map으로 각 요소를 toJSON() 처리
                const { error: videoMusicInfoError } = await this.client.from("MusicInfoJoin").upsert(musicInfoJoinTable.map(item => item.toJSON())).select();
                if (videoMusicInfoError) throw new Error(`MusicInfoJoin(Video) Upsert 실패: ${videoMusicInfoError.message}`);

                const { error: musicStartError } = await this.client.from("MusicStartJoin").upsert(musicStartJoinList.map(item => item.toJSON())).select();
                if (musicStartError) throw new Error(`MusicStartJoin Upsert 실패: ${musicStartError.message}`);
                break;
        }
    }

    async deletePlaylistBody(id: string, playlistType: YTPlaylistTypeDTO) {
        switch (playlistType) {
            case YTPlaylistTypeDTO.OFFICIAL:
                await this.client.from('YTOfficialPlaylist').delete().eq("id", id);
                await this.client.from('MusicInfoJoin').delete().eq("id", id);
                break;
            case YTPlaylistTypeDTO.VIDEO:
                await this.client.from('YTVideoPlaylist').delete().eq("id", id);
                await this.client.from('MusicInfoJoin').delete().eq("id", id);
                await this.client.from('MusicStartJoin').delete().eq("id", id);
                break;
        }
        
    }
}

const result = dotenv.config({ path: '.env', debug: true }); // debug: true 추가

const clientAPI: string = result.parsed?.SUPABASE_API ?? "";
const clientKey: string = result.parsed?.SUPABASE_ANON_KEY ?? "";
const clientURL: string = result.parsed?.SUPABASE_URL ?? "";
// console.log(clientKey, clientAPI, clientURL);
console.log("clientAPI: ", clientAPI);
console.log("clientURL: ", clientURL);
console.log("clientKey: ", clientKey);
if (!clientAPI || !clientKey || !clientURL) {
    throw new Error('SUPABASE_URL과 SUPABASE_ANON_KEY 환경 변수를 설정해주세요.');
}

const playlistCachier = new PlaylistCachier(clientAPI, clientKey);

(async () => {
    try {
        console.log("Upsert 테스트를 시작합니다...");
        const ytPlaylistDTOs: YTPlaylistDTO[] = Array.from({length: 20}, (_, index) => {
            return new YTPlaylistDTO(
                new YTPlaylistHeadDTO(
                    `test_id_00${index}`,
                    "https://www.youtube.com/playlist?list=PL_test_001",
                    `테스트-제목#${index}`,
                    "https://i.ytimg.com/vi/123/hqdefault.jpg",
                    false,
                    new YTChannelInfoDTO("channel_id_001", "플레이리스트헤더테스트-채널이름", 1234123123,"https://i.ytimg.com/channel/123.jpg"),
                    YTPlaylistTypeDTO.VIDEO
                ),
                new YTPlaylistBodyDTO(
                    "https://www.youtube.com/playlist?list=PL_test_001",
                    YTPlaylistTypeDTO.VIDEO,
                    MusicPlatformTypeDTO.APPLE,
                    3,
                    [
                        new MusicInfoTableDTO(`노래이름이자나#${index}`, "isrc_001"),
                        new MusicInfoTableDTO(`App노래le#${index}`, "isrc_002"),
                        new MusicInfoTableDTO(`그렇지#${index}`, "isrc_003"),
                    ],
                    [10, 20, 30]
                )
            )
        });

        for (const ytPlaylistDTO of ytPlaylistDTOs) {
        //     console.log("ytPlaylistDTO: ", {
        //         id: ytPlaylistDTO.head.id,
        //         date: new Date().toISOString(),
        //         locale: "KR",
        //         channelID: ytPlaylistDTO.head.channel.id
        //     });
        // 사용자가 작성한 테스트 데이터로 upsertPlaylist 호출
            await playlistCachier.upsertPlaylist(ytPlaylistDTO);
            const response = await fetch(`${clientURL}/sqoops/log`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${clientKey}`
                },
                body: JSON.stringify({
                    id: ytPlaylistDTO.head.id,
                    date: new Date().toISOString(),
                    locale: "KR",
                    channelID: ytPlaylistDTO.head.channel.id
                })
            })
            console.log("response: ", response);
            if (!response.ok) {
                throw new Error(`HTTP 에러! 상태: ${response.status}, 메시지: ${response.statusText}`);
            }
        }

        console.log("✅ 테스트 성공: 데이터가 성공적으로 처리되었습니다.");

    } catch (error) {
        console.error("❌ 테스트 실패! 에러가 발생했습니다:", error);
    }
})();
