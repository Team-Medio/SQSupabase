# SQSupabase 프로젝트 작업 내역 및 API 사용법

## 📋 프로젝트 개요

SQSupabase는 YouTube 플레이리스트 및 채널 데이터를 관리하고 차트 기능을 제공하는 Supabase Edge Functions 기반의 백엔드 시스템입니다.

### 🏗️ 주요 구성 요소

- **Supabase Edge Functions**: TypeScript/Deno 기반 서버리스 함수
- **PostgreSQL Database**: 데이터 저장 및 관리
- **Python Test Scripts**: API 테스트 및 검증
- **Migration Scripts**: 데이터 마이그레이션 도구

## 🔧 개발 환경 설정

### 1. 필수 도구 설치
```bash
# Supabase CLI 설치
npm install -g @supabase/cli

# Python 의존성 설치
pip install -r requirements.txt
```

### 2. 로컬 개발 서버 시작
```bash
# Supabase 로컬 서버 시작
supabase start

# 서버 정보 확인
# API URL: http://localhost:54321
# DB URL: postgresql://postgres:postgres@localhost:54322/postgres
# Studio URL: http://localhost:54323
```

### 3. 환경 변수 설정
```bash
# .env 파일 생성
export SUPABASE_URL="http://127.0.0.1:54321/functions/v1"
export SUPABASE_ANON_KEY="your-anon-key"
```

## 🚀 API 엔드포인트 및 사용법

### 1. PlaylistIDs 함수 (`/PlaylistIDs`)

플레이리스트 접근 기록 관리 및 조회 기능

#### GET 요청 - 최근 스쿱된 플레이리스트 조회
```bash
curl -X GET "http://127.0.0.1:54321/functions/v1/PlaylistIDs?filter=recent&limitcount=10" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"
```

#### GET 요청 - 특정 기간 가장 많이 스쿱된 플레이리스트 조회
```bash
curl -X GET "http://127.0.0.1:54321/functions/v1/PlaylistIDs?filter=most&period=week&date=2025-08-12&limitcount=10" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json"
```

#### POST 요청 - 플레이리스트 접근 기록 추가
```bash
curl -X POST "http://127.0.0.1:54321/functions/v1/PlaylistIDs" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "playlist_id_123",
    "date": "2025-01-08T12:00:00Z",
    "locale": "KR"
  }'
```

**파라미터:**
- `filter`: `recent` | `most`
- `period`: `week` | `month` | `year` (most 필터 사용 시)
- `date`: 기준 날짜 (YYYY-MM-DD 형식)
- `limitcount`: 반환할 결과 수

### 2. Charts 함수 (`/charts`)

플레이리스트 및 채널 차트 데이터 조회

#### 플레이리스트 차트 조회
```bash
# 최근 스쿱된 플레이리스트 차트
curl -X GET "http://127.0.0.1:54321/functions/v1/charts/playlists?filter=recent&limitcount=10" \
  -H "Authorization: Bearer YOUR_TOKEN"

# 주간 가장 많이 스쿱된 플레이리스트 차트
curl -X GET "http://127.0.0.1:54321/functions/v1/charts/playlists?filter=most&period=week&date=2025-08-12&limitcount=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

#### 채널 차트 조회
```bash
# 최근 스쿱된 채널 차트
curl -X GET "http://127.0.0.1:54321/functions/v1/charts/channels?filter=recent&limitcount=10" \
  -H "Authorization: Bearer YOUR_TOKEN"

# 주간 가장 많이 스쿱된 채널 차트
curl -X GET "http://127.0.0.1:54321/functions/v1/charts/channels?filter=most&period=week&date=2025-08-12&limitcount=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 3. Channels 함수 (`/channels`)

채널 관련 플레이리스트 정보 조회

#### 채널의 플레이리스트 헤더 정보 조회
```bash
curl -X GET "http://127.0.0.1:54321/functions/v1/channels/playlists?channelId=channel_id_001&limitcount=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

#### 채널의 플레이리스트 ID 목록 조회
```bash
curl -X GET "http://127.0.0.1:54321/functions/v1/channels/playlists/id?channelId=channel_id_001&limitcount=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 4. Sqoops 함수 (`/sqoops`)

스쿱 로그 기록 관리

#### 스쿱 로그 기록 추가
```bash
curl -X POST "http://127.0.0.1:54321/functions/v1/sqoops/log" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "playlist_id_123",
    "date": "2025-01-08T12:00:00Z",
    "locale": "KR",
    "channelID": "channel_id_001"
  }'
```

### 5. VersionManager 함수 (`/VersionManager`)

iOS 앱 버전 상태 확인

#### 버전 상태 조회
```bash
curl -X GET "http://127.0.0.1:54321/functions/v1/VersionManager?os=ios&version=1.0.0" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**응답 코드:**
- `200`: 정상 버전
- `다른 코드`: 업데이트 필요 또는 기타 상태

## 🗄️ 데이터베이스 스키마

### 주요 테이블

#### YTPlaylistHead
플레이리스트 메타데이터 저장
```sql
- id: 플레이리스트 ID (Primary Key)
- originURL: 원본 URL
- title: 플레이리스트 제목
- channelID: 채널 ID
- thumbnailURLString: 썸네일 URL
- playlistType: 플레이리스트 타입 ('Official' | 'Video')
- isShazamed: Shazam 처리 여부
- insertedDate: 삽입 날짜
```

#### YTChannelInfo
채널 정보 저장
```sql
- id: 채널 ID (Primary Key)
- name: 채널 이름
- thumbnailURLString: 썸네일 URL
- subscribers: 구독자 수
```

#### RecentSqoopedPlaylists
최근 스쿱된 플레이리스트 기록
```sql
- id: 플레이리스트 ID (Primary Key)
- sqooped_date: 스쿱된 날짜
```

#### SendToPlaylistDate
플레이리스트 스쿱 통계 데이터
```sql
- id: 플레이리스트 ID
- sqooped_date: 스쿱된 날짜
- watchSystem: 시청 시스템 구분
- country_code: 국가 코드
- sqoop_count: 스쿱 횟수
```

#### ChartData
차트 데이터 (채널 기반)
```sql
- id: 플레이리스트 ID
- sqooped_date: 스쿱된 날짜
- watch_system: 시청 시스템
- country_code: 국가 코드
- channel_id: 채널 ID
- sqoop_count: 스쿱 횟수
```

#### Version_iOS
iOS 앱 버전 관리
```sql
- version: 버전 문자열 (Primary Key)
- statusCode: 상태 코드
```

### 주요 뷰

#### WeeklyMostSqoopedPlaylists
주간 가장 많이 스쿱된 플레이리스트 뷰

#### WeeklyMostSqoopedChannels
주간 가장 많이 스쿱된 채널 뷰

## 🧪 테스트 스크립트 사용법

### 1. 통합 테스트 스크립트
```bash
# 대화형 모드 (기본)
python test_cli/test_edge_functions.py

# 모든 테스트 자동 실행
python test_cli/test_edge_functions.py all

# 특정 테스트만 실행
python test_cli/test_edge_functions.py recent
python test_cli/test_edge_functions.py most
python test_cli/test_edge_functions.py post
python test_cli/test_edge_functions.py version
```

### 2. 개별 API 테스트 스크립트

#### Charts API 테스트
```bash
python test_cli/api_test/charts_functions.py
```

#### Channels API 테스트
```bash
python test_cli/api_test/channels_functions.py
```

#### Sqoops API 테스트
```bash
python test_cli/api_test/sqoops_functions.py
```

## 📊 마이그레이션 작업 내역

### 주요 스키마 변경 사항

#### 2025-08-10 (20250810102955_remote_schema.sql)
- 초기 데이터베이스 스키마 생성
- 기본 테이블 및 타입 정의
- 플레이리스트 및 채널 관리 구조 구축

#### 2025-08-11 (20250811021401_remote_schema.sql)
- 스키마 업데이트 및 최적화

#### 2025-08-11 (20250811150202_edit_schema.sql)
- ChartData 테이블 추가 (채널 기반 차트 데이터)
- RecentSqoopedChannels 테이블 추가
- WeeklyMostSqoopedChannels 뷰 추가
- insert_sqooped_log 함수 업데이트

#### 2025-08-12 (20250812161919_edit_schema.sql)
- 추가 스키마 수정 사항

### 데이터 마이그레이션

`migration_scripts/` 디렉토리에 월별 데이터 마이그레이션 파일들이 준비되어 있습니다:
- 2025년 3월~8월 데이터 마이그레이션 JSON 파일들
- `SendtoplaylistToChartData.py`: 플레이리스트 데이터를 차트 데이터로 변환하는 스크립트

## 🔐 인증 및 보안

모든 API 요청은 Bearer Token 인증이 필요합니다:
```bash
Authorization: Bearer YOUR_SUPABASE_ANON_KEY
```

## 🚨 문제 해결

### 연결 실패 시
1. Supabase 로컬 서버 실행 확인: `supabase start`
2. 포트 54321 사용 가능 여부 확인
3. 방화벽 설정 확인

### 인증 오류 시
1. SUPABASE_ANON_KEY 환경 변수 확인
2. Bearer 토큰 형식 확인
3. 토큰 만료 여부 확인

### 함수 오류 시
1. Edge Functions 배포 상태 확인
2. 함수 로그 확인: `supabase logs --type functions`
3. 데이터베이스 연결 상태 확인

## 📈 향후 개선 사항

1. API 문서 자동화 (Swagger/OpenAPI)
2. 에러 핸들링 개선
3. 캐싱 전략 구현
4. 모니터링 및 로깅 강화
5. 테스트 커버리지 확장

---

**마지막 업데이트:** 2025년 1월 8일  
**프로젝트 버전:** 1.0.0  
**문서 버전:** 1.0.0
