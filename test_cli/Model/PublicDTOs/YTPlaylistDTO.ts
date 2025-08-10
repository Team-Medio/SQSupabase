import { YTPlaylistHeadDTO } from './YTPlaylistHeadDTO';
import { YTPlaylistBodyDTO } from './YTPlaylistBodyDTO';
import { MusicPlatformTypeDTO } from './PublicTypeDTOs';
import { MusicInfoTableDTO } from './MusicInfoTableDTO';

/**
 * 유튜브 플레이리스트 전체 정보 DTO
 */
export class YTPlaylistDTO {
  public readonly head: YTPlaylistHeadDTO;
  public readonly body: YTPlaylistBodyDTO;

  /**
   * 메타데이터와 PlaylistData 둘 존재하는 경우 사용합니다.
   */
  constructor(head: YTPlaylistHeadDTO, body: YTPlaylistBodyDTO) {
    this.head = head;
    this.body = body;
  }

  /**
   * 헤드 정보를 기반으로 바디를 생성하는 생성자
   */
  static createWithHeadAndInfo(
    head: YTPlaylistHeadDTO,
    totalInfo: number,
    musicPlatform: MusicPlatformTypeDTO,
    musicInfos: MusicInfoTableDTO[],
    startTime: number[] | null = null
  ): YTPlaylistDTO {
    const body = new YTPlaylistBodyDTO(
      head.originURL,
      head.ytPlaylistType,
      musicPlatform,
      totalInfo,
      musicInfos,
      startTime
    );
    
    return new YTPlaylistDTO(head, body);
  }

  toJSON() {
    return {
      head: this.head.toJSON(),
      body: this.body.toJSON()
    };
  }

  static fromJSON(json: any): YTPlaylistDTO {
    return new YTPlaylistDTO(
      YTPlaylistHeadDTO.fromJSON(json.head),
      YTPlaylistBodyDTO.fromJSON(json.body)
    );
  }
}
