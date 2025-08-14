# Sqoops API 문서

## 개요

Sqoops API는 YouTube 플레이리스트의 스쿱(재생) 로그를 기록하고 관리하는 Edge Function입니다. 사용자가 플레이리스트를 재생할 때마다 해당 정보를 데이터베이스에 저장하여 데이터를 수집합니다.

## API 엔드포인트

### Base URL
- Production: `https://your-project.supabase.co/functions/v1/channels`

## 엔드포인트

### 1. 스쿱 로그 기록 (`/log`)

플레이리스트 스쿱 로그를 기록합니다.

#### 요청 정보
- **메서드**: `POST`
- **경로**: `/sqoops/log`
- **인증**: Bearer Token 필요

#### 요청 헤더
```
Authorization: Bearer YOUR_SUPABASE_ANON_KEY
Content-Type: application/json
```

#### 요청 본문 (JSON)
```json
{
  "id": "string",           // 플레이리스트 ID (필수)
  "date": "2025-01-08T12:00:00Z",  // 클라이언트 전송 날짜 (UTC 시간 반영 위함) (필수)
  "locale": "KR",           // 지역 코드 (선택사항, null 가능)
  "channelID": "string"     // 채널 ID (필수)
}
```

#### 필드 설명
- `id`: YouTube 플레이리스트의 고유 ID
- `date`: 스쿱이 발생한 시간 (ISO 8601 형식, UTC 시간대)
- `locale`: 국가/지역 코드 (예: "KR", "US", "JP" 등)
- `channelID`: YouTube 채널의 고유 ID

#### 응답

**성공 응답 (200)**

**에러 응답**
- `401`: 인증 실패
- `405`: 잘못된 HTTP 메서드
- `500`: 서버 내부 오류

#### 사용 예시

**CURL**
```bash
curl -X POST "https://your-project.supabase.co/functions/v1/sqoops/log" \
  -H "Authorization: Bearer YOUR_SUPABASE_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "id": "PLrAXtmRdnEQyJcHfzXzqXqXqXqXqXqXq",
    "date": "2025-01-08T12:00:00Z",
    "locale": "KR",
    "channelID": "UCqXqXqXqXqXqXqXqXqXqXqXq"
  }'
```

**JavaScript/TypeScript**
```typescript
const response = await fetch('https://your-project.supabase.co/functions/v1/sqoops/log', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    id: 'PLrAXtmRdnEQyJcHfzXzqXqXqXqXqXqXqXqXqXq',
    date: new Date().toISOString(),
    locale: 'KR',
    channelID: 'UCqXqXqXqXqXqXqXqXqXqXqXqXqXqXqXq'
  })
});

const result = await response.json();
```

## 내부 동작 원리

### 1. 데이터 처리 과정
1. 클라이언트에서 스쿱 로그 요청 전송
2. `insert_sqooped_log_v2` RPC 함수 호출
3. 다음 작업들이 순차적으로 실행:
   - **ChartData 테이블 업데이트**: 동일한 플레이리스트/날짜/시간대/채널 조합이 있으면 `sqoop_count` 증가, 없으면 새 레코드 생성
   - **RecentSqoopedChannels 테이블 업데이트**: 채널의 최근 스쿱 시간 업데이트

### 2. 시간대 구분 (watch_system)
- 시간을 3시간 단위로 나누어 구분
- 예: 0-2시 = 0, 3-5시 = 1, 6-8시 = 2, ...

### 3. 중복 처리
- 동일한 플레이리스트를 같은 날짜, 같은 시간대에 스쿱하면 카운트만 증가
- 채널별 최근 스쿱 시간은 항상 최신 시간으로 업데이트