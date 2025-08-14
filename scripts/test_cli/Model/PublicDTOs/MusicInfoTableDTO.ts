/**
 * 음악 정보 키값들을 전송하는 테이블
 * platformKey: 플랫폼에 저장된 고유 노래 키
 * ISRC: 국제 협약 고유 노래 키
 */
export class MusicInfoTableDTO {
  public readonly platformKey: string;
  public readonly isrc: string;

  constructor(platformKey: string, isrc: string) {
    this.platformKey = platformKey;
    this.isrc = isrc;
  }

  toJSON() {
    return {
      platformKey: this.platformKey,
      isrc: this.isrc
    };
  }

  static fromJSON(json: any): MusicInfoTableDTO {
    return new MusicInfoTableDTO(
      json.platformKey,
      json.isrc
    );
  }
}
