import { YTPlaylistTypeDTO, MusicPlatformTypeDTO, TotalInfoTypeDTO } from './PublicTypeDTOs';
import { MusicInfoTableDTO } from './MusicInfoTableDTO';

/**
 * 플레이리스트 정보를 담는 DTO
 */
export class YTPlaylistBodyDTO {
  public readonly originURL: string; // 유튜브 URL
  public readonly ytPlaylistType: YTPlaylistTypeDTO; // 플레이리스트 타입
  public readonly musicPlatform: MusicPlatformTypeDTO; // 음악 플랫폼
  public readonly totalInfo: TotalInfoTypeDTO;
  public readonly musicInfos: MusicInfoTableDTO[];
  public readonly startTimes: number[] | null;

  /**
   * @param originURL 유튜브 URL 입니다.
   * @param ytPlaylistType 플레이리스트 타입입니다. - official, video
   * @param musicPlatform 음악 플랫폼 입니다. - apple, spotify
   * @param totalInfo 총 정보입니다.
   * @param musicInfos 음악 정보가 들은 배열입니다.
   * @param startTimes 음악의 시작 시간 들어있는 배열입니다. - video에서 사용
   */
  constructor(
    originURL: string,
    ytPlaylistType: YTPlaylistTypeDTO,
    musicPlatform: MusicPlatformTypeDTO = MusicPlatformTypeDTO.APPLE,
    totalInfo: number,
    musicInfos: MusicInfoTableDTO[],
    startTimes: number[] | null = null
  ) {
    this.originURL = originURL;
    this.ytPlaylistType = ytPlaylistType;
    this.totalInfo = TotalInfoTypeDTO.makeByPlaylistType(ytPlaylistType, totalInfo);
    this.musicPlatform = musicPlatform;
    this.musicInfos = musicInfos;
    this.startTimes = startTimes;
  }

  toJSON() {
    return {
      originURL: this.originURL,
      ytPlaylistType: this.ytPlaylistType,
      musicPlatform: this.musicPlatform,
      totalInfo: this.totalInfo.toJSON(),
      musicInfos: this.musicInfos.map(info => info.toJSON()),
      startTimes: this.startTimes
    };
  }

  static fromJSON(json: any): YTPlaylistBodyDTO {
    const musicInfos = json.musicInfos.map((info: any) => MusicInfoTableDTO.fromJSON(info));
    const totalInfoValue = json.totalInfo.value || json.totalInfo;
    
    return new YTPlaylistBodyDTO(
      json.originURL,
      json.ytPlaylistType as YTPlaylistTypeDTO,
      json.musicPlatform as MusicPlatformTypeDTO,
      totalInfoValue,
      musicInfos,
      json.startTimes
    );
  }
}
