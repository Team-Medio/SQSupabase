
export class MusicInfoJoinTable {
    id: string;
    musicPlatformType: string;
    musicKey: string;
    idx: number;
    ISRC: string;

    constructor(
        id: string,
        musicPlatformType: string,
        musicKey: string,
        idx: number,
        ISRC: string
    ) {
        this.id = id;
        this.musicPlatformType = musicPlatformType;
        this.musicKey = musicKey;
        this.idx = idx;
        this.ISRC = ISRC;
    }

    toJSON() {
        return {
            id: this.id,
            musicPlatformType: this.musicPlatformType,
            musicKey: this.musicKey,
            idx: this.idx,
            ISRC: this.ISRC
        };
    }
}