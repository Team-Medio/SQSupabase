/**
 * 애플 뮤직, 스포티파이 등 뮤직 플랫폼을 구분하는 열거형
 * Enum String 프로토콜을 따라서 rawValue로 DB와 값을 주고 받을 수 있습니다.
 */
export enum MusicPlatformTypeDTO {
  APPLE = "Apple",
  SPOTIFY = "Spotify"
}

/**
 * 사용자가 가져오는 유튜브 플레이리스트 타입을 구분하는 열거형
 */
export enum YTPlaylistTypeDTO {
  OFFICIAL = "Official",
  VIDEO = "Video"
}

/**
 * 총 정보 타입을 나타내는 클래스
 */
export class TotalInfoTypeDTO {
  private _type: 'length' | 'duration';
  private _value: number;

  constructor(type: 'length' | 'duration', value: number) {
    this._type = type;
    this._value = value;
  }

  get type(): 'length' | 'duration' {
    return this._type;
  }

  get value(): number {
    return this._value;
  }

  static makeByPlaylistType(playlistType: YTPlaylistTypeDTO, num: number): TotalInfoTypeDTO {
    switch (playlistType) {
      case YTPlaylistTypeDTO.OFFICIAL:
        return new TotalInfoTypeDTO('length', num);
      case YTPlaylistTypeDTO.VIDEO:
        return new TotalInfoTypeDTO('duration', num);
      default:
        throw new Error(`Unknown playlist type: ${playlistType}`);
    }
  }

  toJSON() {
    return {
      type: this._type,
      value: this._value
    };
  }
}
