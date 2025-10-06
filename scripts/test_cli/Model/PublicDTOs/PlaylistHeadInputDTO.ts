/**
 * 원시 입력 데이터 타입들 (API/스크래퍼 등 외부에서 들어오는 형태)
 * 기존 DTO(YTPlaylistHeadDTO 등)로 매핑하기 전의 형태를 명확히 합니다.
 */

/** ISO 8601 문자열 */
export type ISODateString = string;

/** 유튜브 플레이리스트 타입의 원시 문자열 값 */
export type YTPlaylistTypeRaw = 'Official' | 'Video';

/**
 * 채널 정보가 분리되어 제공되는 경우(채널 ID/이름만 제공) 포함한 입력 항목
 * 제공된 예시 데이터의 각 객체 1개를 표현합니다.
 */
export interface YTPlaylistHeadInputDTO {
  id: string;
  originURL: string;
  title: string;
  thumbnailURLString: string;
  insertedDate: ISODateString;
  isShazamed: boolean;
  playlistType: YTPlaylistTypeRaw;
  channelID: string;
  channelName: string;
}

let id: String
    let originURL:String
    let title:String
    let thumbnailURLString: String
    let insertedDate:Date
    let isShazamed: Bool
    let playlistType: YTPlaylistTypeDTO.RawValue
    var channelID: String
    let channelName: String

/** 입력 항목 배열 */
export type YTPlaylistHeadInputListDTO = YTPlaylistHeadInputDTO[];


