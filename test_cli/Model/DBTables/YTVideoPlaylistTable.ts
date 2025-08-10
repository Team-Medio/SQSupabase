export class YTVideoPlaylistTable {
    id: string;
    playLength: number;
    musicPlatformType: string;

    constructor(
        id: string,
        playLength: number,
        musicPlatformType: string
    ) {
        this.id = id;
        this.playLength = playLength;
        this.musicPlatformType = musicPlatformType;
    }

    toJSON() {
        return {
            id: this.id,
            playLength: this.playLength,
            musicPlatformType: this.musicPlatformType
        };
    }
}
