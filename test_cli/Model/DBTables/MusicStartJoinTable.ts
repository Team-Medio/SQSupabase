
export class MusicStartJoinTable {
    id: string;
    idx: number;
    startTime: number;

    constructor(
        id: string,
        idx: number,
        startTime: number
    ) {
        this.id = id;
        this.idx = idx;
        this.startTime = startTime;
    }

    toJSON() {
        return {
            id: this.id,
            idx: this.idx,
            startTime: this.startTime
        };
    }
}
