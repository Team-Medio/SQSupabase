# Refactor/#1 브랜치 작업 내역

## 📋 브랜치 개요
- **브랜치명**: `refactor/#1-doc-init-legacy-refactoring`
- **목적**: API 문서화 및 프로젝트 구조 정리
- **기간**: 2025년 8월 14일까지

## 🔄 주요 커밋 내역

### 1. [Doc] API 문서화 및 프로젝트 디렉토리 정리 (a54e865)
- **작업 내용**:
  - API 문서화 완료 (channels, charts, sqoops)
  - 프로젝트 디렉토리 구조 정리
  - test_cli 폴더를 scripts/test_cli로 이동
  - README.md 업데이트

### 2. [Feat] 문서화 및 기록 추가 (befc30a)
- **작업 내용**:
  - 프로젝트 작업 내역 문서 추가
  - API 사용법 문서 작성

### 3. [Feat] 채널 정보 조회 API 제작 (620a30f)
- **작업 내용**:
  - channels edge function 구현
  - 채널 정보 조회 엔드포인트 추가

### 4. [Feat] Chart Get API 제작 (8800ef8)
- **작업 내용**:
  - charts edge function 구현
  - 플레이리스트/채널 차트 API 추가

### 5. [Feat] Sqoops edge function 로컬 테스트 용 파이썬 스크립트 제작 (71d8073)
- **작업 내용**:
  - 로컬 테스트용 Python 스크립트 작성
  - API 테스트 자동화

### 6. [Feat] sqoops edgefunction 추가 (b752556)
- **작업 내용**:
  - sqoops edge function 구현
  - 스쿱 로그 관련 API 추가

### 7. [Feat] 새 차트를 위한 DB 구성 및 EdgeFunction 제작 (dca517f)
- **작업 내용**:
  - 차트 데이터베이스 스키마 구성
  - 차트 관련 Edge Function 제작

### 8. [Feat] 테스트용 Service Storage ts제작 (a2f5073)
- **작업 내용**:
  - TypeScript 테스트 서비스 스토리지 구현
  - 테스트 환경 구축

### 9. [Refactor] Supabase local 값 Fetch, 최근 플리 api 메서드 변경 (4361529)
- **작업 내용**:
  - Supabase 로컬 환경 설정 개선
  - 최근 플레이리스트 API 메서드 리팩토링

### 10. [Refactor] Supabase MCP 적용 (09e05af)
- **작업 내용**:
  - Supabase MCP(Model Context Protocol) 적용
  - 개발 환경 표준화

## 📁 새로 생성된 파일들

### 문서 파일
- `docs/channels_doc.md` - 채널 API 문서
- `docs/charts_doc.md` - 차트 API 문서  
- `docs/sqoops_doc.md` - 스쿱 API 문서
- `README.md` - 프로젝트 메인 README

### Edge Functions
- `supabase/functions/channels/` - 채널 관련 API
- `supabase/functions/charts/` - 차트 관련 API
- `supabase/functions/sqoops/` - 스쿱 관련 API

### 테스트 파일
- `scripts/test_cli/` - 테스트 클라이언트 (기존 test_cli에서 이동)
- `scripts/migration_scripts/` - 마이그레이션 스크립트

### 데이터베이스
- `supabase/migrations/20250812161919_edit_schema.sql` - 스키마 변경사항

## 🔧 구현된 API 엔드포인트

### Channels API
- **GET** `/functions/v1/channels/playlists` - 채널의 플레이리스트 조회

### Charts API
- **GET** `/functions/v1/charts/playlists` - 플레이리스트 차트 조회
- **GET** `/functions/v1/charts/channels` - 채널 차트 조회

### Sqoops API
- **POST** `/functions/v1/sqoops/log` - 스쿱 로그 기록

## 📊 데이터베이스 변경사항

### 새로운 테이블
- `RecentSqoopedPlaylists` - 최근 스쿱된 플레이리스트
- `RecentSqoopedChannels` - 최근 스쿱된 채널
- `MonthlyMostSqoopedPlaylists` - 월간 가장 많이 스쿱된 플레이리스트
- `MonthlyMostSqoopedChannels` - 월간 가장 많이 스쿱된 채널

### RPC 함수
- `get_weekly_most_sqooped_playlists_v1` - 주간 가장 많이 스쿱된 플레이리스트
- `get_weekly_most_sqooped_channels_v1` - 주간 가장 많이 스쿱된 채널

## 🎯 주요 성과

1. **API 문서화 완료**: 모든 Edge Function에 대한 상세한 사용법 문서 작성
2. **프로젝트 구조 정리**: 체계적인 디렉토리 구조로 개선
3. **테스트 환경 구축**: 로컬 테스트 및 API 테스트 자동화
4. **차트 시스템 구현**: 주간/월간 차트 데이터 제공 기능
5. **코드 품질 개선**: TypeScript 타입 정의 및 에러 처리 강화

## 🔗 연관 RPC Function

### get_weekly_most_sqooped_channels_v1
```typescript
{
    now_date: date.toDateString(), 
    limit_count: limit 
}
```
#### 연관 테이블
1. WeeklyMostSqoopedChannels
#### 연관 Edge Function API
- charts/channels/most/...

### get_weekly_most_sqooped_playlists_v1
```typescript
{
    now_date: date.toDateString(), 
    limit_count: limit 
}
```
#### 연관 테이블
1. WeeklyMostSqoopedPlaylists
#### 연관 Edge Function API
- charts/playlists/most/...

### MonthlyMostSqoopedChannels
- 월간 가장 많이 스쿱된 채널 데이터
- charts/channels/most/... (period=month)

### MonthlyMostSqoopedPlaylists  
- 월간 가장 많이 스쿱된 플레이리스트 데이터
- charts/playlists/most/... (period=month)

## 📝 다음 작업 계획

1. **API 성능 최적화**: 쿼리 성능 개선 및 캐싱 전략 수립
2. **모니터링 시스템**: API 사용량 및 에러 모니터링 구축
3. **보안 강화**: 인증 및 권한 관리 시스템 개선
4. **테스트 커버리지 확대**: 단위 테스트 및 통합 테스트 추가