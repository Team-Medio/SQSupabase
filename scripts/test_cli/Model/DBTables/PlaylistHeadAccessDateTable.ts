
export class PlaylistHeadAccessDateTable {
    id: string;
    access: Date;

    constructor(id: string, accessDateString?: string) {
        this.id = id;
        if (accessDateString) {
            // ISO 8601 format with timezone "yyyy-MM-dd'T'HH:mm:ssXXX"
            this.access = new Date(accessDateString);
            if (isNaN(this.access.getTime())) {
                throw new Error("Date convert failed");
            }
        } else {
            this.access = new Date();
        }
    }

    toJSON() {
        return {
            id: this.id,
            access: this.access.toISOString()
        };
    }
}
