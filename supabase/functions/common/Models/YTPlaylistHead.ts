import { YTChannelInfo } from "./YTChannelInfo.ts";

export type YTPlaylistHead = {
    id: string;
    originURL: string;
    insertedDate: Date;
    isShazamed: boolean;
    thumbnailURL: string;
    title: string;
    channel: YTChannelInfo;
    ytPlaylistType: string; // "Official" or "Video"
}