

export class YTOfficialPlaylistTable {
    id: string;
    totalSongCount: number;
    musicPlatformType: string;

    constructor(
        id: string,
        totalSongCount: number,
        musicPlatformType: string
    ) {
        this.id = id;
        this.totalSongCount = totalSongCount;
        this.musicPlatformType = musicPlatformType;
    }

    toJSON() {
        return {
            id: this.id,
            totalSongCount: this.totalSongCount,
            musicPlatformType: this.musicPlatformType
        };
    }
}
