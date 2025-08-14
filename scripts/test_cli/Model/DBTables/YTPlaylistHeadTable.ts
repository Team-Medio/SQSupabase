import { YTPlaylistHeadDTO } from "../PublicDTOs";

export class YTPlaylistHeadTable {
    id: string;
    originURL: string;
    title: string;
    channelID: string;
    thumbnailURLString: string;
    insertedDate: Date;
    isShazamed: boolean;
    playlistType: string;

    constructor(
        id: string,
        originURL: string,
        title: string,
        channelID: string,
        thumbnailURLString: string,
        insertedDate: Date | string,
        isShazamed: boolean,
        playlistType: string
    ) {
        this.id = id;
        this.originURL = originURL;
        this.title = title;
        this.channelID = channelID;
        this.thumbnailURLString = thumbnailURLString;
        this.isShazamed = isShazamed;
        this.playlistType = playlistType;

        if (typeof insertedDate === 'string') {
            this.insertedDate = new Date(insertedDate);
            if (isNaN(this.insertedDate.getTime())) {
                throw new Error("Date convert failed for insertedDate");
            }
        } else {
            this.insertedDate = insertedDate;
        }
    }

    static fromYTPlaylistHeadDTO(headDTO: YTPlaylistHeadDTO): YTPlaylistHeadTable {
        return new YTPlaylistHeadTable(
            headDTO.id,
            headDTO.originURL,
            headDTO.title,
            headDTO.channel.id,
            headDTO.thumbnailURL,
            headDTO.insertedDate,
            headDTO.isShazamed,
            headDTO.ytPlaylistType
        );
    }

    toJSON() {
        return {
            id: this.id,
            originURL: this.originURL,
            insertedDate: this.insertedDate.toISOString(),
            isShazamed: this.isShazamed,
            thumbnailURLString: this.thumbnailURLString,
            channelID: this.channelID,
            playlistType: this.playlistType,
            title: this.title
        };
    }
}
