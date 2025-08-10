/**
 * 플레이리스트 캐셔 관련 에러를 나타내는 열거형
 */
export enum PlaylistCachierError {
  DATE_CONVERT_FAILED = "날짜 변환 실패",
  CLIENT_KEY_NOT_ENTERED = "클라이언트 키를 설정하지 않았습니다.",
  UNKNOWN_CREATE_FAILED = "알 수 없는 플레이리스트 생성 실패",
  UNKNOWN_GET_FAILED = "알 수 없는 플레이리스트 가져오기 실패",
  PLAYLIST_NOT_EXIST = "플레이리스트 없음",
  MUSIC_KEY_LOSS = "플레이리스트 내부 음악 정보가 손실",
  OVER_ONE_MONTH = "1개월 이상 플레이리스트 캐시 불가",
  META_DATA_NOT_FOUND = "메타 데이터를 가져올 수 없음",
  NOT_MATCH_VIDEO_START_TIME = "플레이리스트 시작 시간 배열과 음악 배열 불일치"
}

/**
 * 플레이리스트 캐셔 에러를 처리하는 클래스
 */
export class PlaylistCachierErrorHandler extends Error {
  public readonly errorType: PlaylistCachierError;

  constructor(errorType: PlaylistCachierError) {
    super(errorType);
    this.name = 'PlaylistCachierError';
    this.errorType = errorType;
  }

  static dateConvertFailed(): PlaylistCachierErrorHandler {
    return new PlaylistCachierErrorHandler(PlaylistCachierError.DATE_CONVERT_FAILED);
  }

  static clientKeyNotEntered(): PlaylistCachierErrorHandler {
    return new PlaylistCachierErrorHandler(PlaylistCachierError.CLIENT_KEY_NOT_ENTERED);
  }

  static unknownCreateFailed(): PlaylistCachierErrorHandler {
    return new PlaylistCachierErrorHandler(PlaylistCachierError.UNKNOWN_CREATE_FAILED);
  }

  static unknownGetFailed(): PlaylistCachierErrorHandler {
    return new PlaylistCachierErrorHandler(PlaylistCachierError.UNKNOWN_GET_FAILED);
  }

  static playlistNotExist(): PlaylistCachierErrorHandler {
    return new PlaylistCachierErrorHandler(PlaylistCachierError.PLAYLIST_NOT_EXIST);
  }

  static musicKeyLoss(): PlaylistCachierErrorHandler {
    return new PlaylistCachierErrorHandler(PlaylistCachierError.MUSIC_KEY_LOSS);
  }

  static overOneMonth(): PlaylistCachierErrorHandler {
    return new PlaylistCachierErrorHandler(PlaylistCachierError.OVER_ONE_MONTH);
  }

  static metaDataNotFound(): PlaylistCachierErrorHandler {
    return new PlaylistCachierErrorHandler(PlaylistCachierError.META_DATA_NOT_FOUND);
  }

  static notMatchVideoStartTime(): PlaylistCachierErrorHandler {
    return new PlaylistCachierErrorHandler(PlaylistCachierError.NOT_MATCH_VIDEO_START_TIME);
  }
}
