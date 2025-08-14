
export class RecentSqoopedPlaylists {
    id: string;
    sqooped_date: Date;

    constructor(id: string, sqooped_date?: string) {
        this.id = id;
        if (sqooped_date) {
            // ISO 8601 format with timezone "yyyy-MM-dd'T'HH:mm:ssXXX"
            this.sqooped_date = new Date(sqooped_date);
            if (isNaN(this.sqooped_date.getTime())) {
                throw new Error("Date convert failed");
            }
        } else {
            this.sqooped_date = new Date();
        }
    }

    toJSON() {
        return {
            id: this.id,
            sqooped_date: this.sqooped_date.toISOString()
        };
    }
}
