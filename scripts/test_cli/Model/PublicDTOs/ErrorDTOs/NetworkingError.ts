/**
 * 네트워킹 관련 에러를 나타내는 열거형
 */
export enum NetworkingError {
  DATA_CONVERT_FAILED = "네트워크 요청과 일치하는 데이터 타입이 아님"
}

/**
 * 네트워킹 에러를 처리하는 클래스
 */
export class NetworkingErrorHandler extends Error {
  public readonly errorType: NetworkingError;

  constructor(errorType: NetworkingError) {
    super(errorType);
    this.name = 'NetworkingError';
    this.errorType = errorType;
  }

  static dataConvertFailed(): NetworkingErrorHandler {
    return new NetworkingErrorHandler(NetworkingError.DATA_CONVERT_FAILED);
  }
}
