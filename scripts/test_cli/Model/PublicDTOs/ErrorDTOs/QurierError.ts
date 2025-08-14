/**
 * 쿼리 관련 에러를 나타내는 열거형
 */
export enum QurierError {
  INVALID_QUERY = "유효하지 않은 쿼리"
}

/**
 * 쿼리 에러를 처리하는 클래스
 */
export class QurierErrorHandler extends Error {
  public readonly errorType: QurierError;

  constructor(errorType: QurierError) {
    super(errorType);
    this.name = 'QurierError';
    this.errorType = errorType;
  }

  static invalidQuery(): QurierErrorHandler {
    return new QurierErrorHandler(QurierError.INVALID_QUERY);
  }
}
