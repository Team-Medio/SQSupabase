import { YTChannelInfoDTO } from './YTChannelInfoDTO';
import { YTPlaylistTypeDTO } from './PublicTypeDTOs';
import { YTPlaylistHeadTable } from '../DBTables/YTPlaylistHeadTable';

/**
 * 플리 메타데이터를 담는 DTO
 */
export class YTPlaylistHeadDTO {
  public readonly id: string;
  public readonly originURL: string;
  public readonly insertedDate: Date;
  public readonly isShazamed: boolean;
  public readonly thumbnailURL: string;
  public readonly title: string;
  public readonly channel: YTChannelInfoDTO;
  public readonly ytPlaylistType: YTPlaylistTypeDTO;

  /**
   * @param id 유튜브 영상 고유 ID 입니다.
   * @param originURL 유튜브 URL 입니다.
   * @param title 플레이리스트 이름 입니다.
   * @param thumbnailURL 썸네일 URL 입니다.
   * @param isShazamed 샤잠 처리가 되었는지 확인합니다.
   * @param channel 채널 정보입니다.
   * @param ytPlaylistType 유튜브 플레이리스트 타입입니다.
   */
  constructor(
    id: string,
    originURL: string,
    title: string,
    thumbnailURL: string,
    isShazamed: boolean,
    channel: YTChannelInfoDTO,
    ytPlaylistType: YTPlaylistTypeDTO
  ) {
    this.id = id;
    this.originURL = originURL;
    this.insertedDate = new Date();
    this.isShazamed = isShazamed;
    this.thumbnailURL = thumbnailURL;
    this.title = title;
    this.channel = channel;
    this.ytPlaylistType = ytPlaylistType;
  }
  
  static fromYTPlaylistHeadTable(headData: YTPlaylistHeadTable, channelTable: YTChannelInfoDTO): YTPlaylistHeadDTO {
    return new YTPlaylistHeadDTO(
        headData.id,
        headData.originURL,
        headData.title,
        headData.thumbnailURLString,
        headData.isShazamed,
        channelTable,
        headData.playlistType as YTPlaylistTypeDTO
    );
  }

  toJSON() {
    return {
      id: this.id,
      originURL: this.originURL,
      insertedDate: this.insertedDate.toISOString(),
      isShazamed: this.isShazamed,
      thumbnailURL: this.thumbnailURL,
      title: this.title,
      channel: this.channel.toJSON(),
      ytPlaylistType: this.ytPlaylistType
    };
  }

  static fromJSON(json: any): YTPlaylistHeadDTO {
    return new YTPlaylistHeadDTO(
      json.id,
      json.originURL,
      json.title,
      json.thumbnailURL,
      json.isShazamed,
      YTChannelInfoDTO.fromJSON(json.channel),
      json.ytPlaylistType as YTPlaylistTypeDTO
    );
  }
}
