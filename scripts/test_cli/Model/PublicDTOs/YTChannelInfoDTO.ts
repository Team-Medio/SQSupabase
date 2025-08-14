/**
 * 유튜브 채널 정보를 담는 DTO
 */
export class YTChannelInfoDTO {
  public readonly id: string;
  public readonly name: string;
  public subscribers: number;
  public thumbnailURLString: string;

  constructor(
    id: string,
    name: string,
    subscribers: number = 0,
    thumbnailURLString: string = ""
  ) {
    this.id = id;
    this.name = name;
    this.subscribers = subscribers;
    this.thumbnailURLString = thumbnailURLString;
  }

  toJSON() {
    return {
      id: this.id,
      name: this.name,
      subscribers: this.subscribers,
      thumbnailURLString: this.thumbnailURLString
    };
  }

  static fromJSON(json: any): YTChannelInfoDTO {
    return new YTChannelInfoDTO(
      json.id,
      json.name,
      json.subscribers || 0,
      json.thumbnailURLString || ""
    );
  }
}
