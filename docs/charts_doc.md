# Charts Edge Function API 사용법

## 개요
Charts Edge Function은 YouTube 플레이리스트와 채널의 차트 데이터를 제공하는 API입니다. 최근 스쿱된 항목과 기간별 가장 많이 스쿱된 항목을 조회할 수 있습니다.

## BASE URL
- Production: `https://your-project.supabase.co/functions/v1/channels`

## 인증
모든 요청에는 Authorization 헤더가 필요합니다:
```
Authorization: Bearer [YOUR_ANON_KEY]
```

## 엔드포인트

### 1. 플레이리스트 차트 (`/playlists`)

#### GET 요청
```
GET /functions/v1/charts/playlists
```

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|---------|------|------|--------|------|
| `filter` | string | 예 | - | 필터 타입 (`recent` 또는 `most`) |
| `limitcount` | number | 아니오 | 10 | 반환할 결과 개수 |
| `period` | string | `filter=most`일 때 | - | 기간 타입 (`week` 또는 `month`) |
| `date` | string | `filter=most`일 때 | - | 기준 날짜 (YYYY-MM-DD 형식) |

### 파라미터 타입
 **filter**
- `recent`: 최근 스쿱된 항목들을 시간 역순으로 정렬, 순서 보장
- `most`: 지정된 기간 동안 가장 많이 스쿱된 항목들을 스쿱 개수 순으로 정렬, 순서 보장

**period(filter=most일 때만 사용)**
- `week`: 주간 통계
- `month`: 월간 통계

#### 사용 예시

**최근 스쿱된 플레이리스트 조회:**
```bash
curl -X GET "https://[YOUR_PROJECT_REF].supabase.co/functions/v1/charts/playlists?filter=recent&limitcount=5" \
  -H "Authorization: Bearer [YOUR_ANON_KEY]"
```

**주간 가장 많이 스쿱된 플레이리스트 조회:**
```bash
curl -X GET "https://[YOUR_PROJECT_REF].supabase.co/functions/v1/charts/playlists?filter=most&period=week&date=2024-01-15&limitcount=10" \
  -H "Authorization: Bearer [YOUR_ANON_KEY]"
```

**월간 가장 많이 스쿱된 플레이리스트 조회:**
```bash
curl -X GET "https://[YOUR_PROJECT_REF].supabase.co/functions/v1/charts/playlists?filter=most&period=month&date=2024-01-15&limitcount=20" \
  -H "Authorization: Bearer [YOUR_ANON_KEY]"
```

#### 응답 형식

**최근 스쿱된 플레이리스트:**
```json
{
  "PlaylistHeads": [
    {
      "id": "test_id_0013",
      "originURL": "https://www.youtube.com/playlist?list=PL_test_001",
      "insertedDate": "2025-08-16T17:25:44.286+00:00",
      "isShazamed": false,
      "thumbnailURLString": "https://i.ytimg.com/vi/123/hqdefault.jpg",
      "playlistType": "Video",
      "title": "테스트-제목#13",
      "channelID": "channel_id_001"
    },
    {
      "id": "test_id_0012",
      "originURL": "https://www.youtube.com/playlist?list=PL_test_001",
      "insertedDate": "2025-08-16T17:25:44.286+00:00",
      "isShazamed": false,
      "thumbnailURLString": "https://i.ytimg.com/vi/123/hqdefault.jpg",
      "playlistType": "Video",
      "title": "테스트-제목#12",
      "channelID": "channel_id_001"
    }
  ],
  "FailedPlaylistIDs": [
    "failed_playlist_id_1",
    "failed_playlist_id_2"
  ]
}
```


**가장 많이 스쿱된 플레이리스트:**
```json
{
  "PlaylistHeads": [
    {
      "id": "test_id_0013",
      "originURL": "https://www.youtube.com/playlist?list=PL_test_001",
      "insertedDate": "2025-08-16T17:25:44.286+00:00",
      "isShazamed": false,
      "thumbnailURLString": "https://i.ytimg.com/vi/123/hqdefault.jpg",
      "playlistType": "Video",
      "title": "테스트-제목#13",
      "channelID": "channel_id_001"
    },
    {
      "id": "test_id_0012",
      "originURL": "https://www.youtube.com/playlist?list=PL_test_001",
      "insertedDate": "2025-08-16T17:25:44.286+00:00",
      "isShazamed": false,
      "thumbnailURLString": "https://i.ytimg.com/vi/123/hqdefault.jpg",
      "playlistType": "Video",
      "title": "테스트-제목#12",
      "channelID": "channel_id_001"
    }
  ],
  "FailedPlaylistIDs": [
    "failed_playlist_id_1",
    "failed_playlist_id_2"
  ]
}
```

### 2. 채널 차트 (`/channels`)

#### GET 요청
```
GET /functions/v1/charts/channels
```

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|---------|------|------|--------|------|
| `filter` | string | 예 | - | 필터 타입 (`recent` 또는 `most`) |
| `limitcount` | number | 아니오 | 10 | 반환할 결과 개수 |
| `period` | string | `filter=most`일 때 | - | 기간 타입 (`week` 또는 `month`) |
| `date` | string | `filter=most`일 때 | - | 기준 날짜 (YYYY-MM-DD 형식) |

### 파라미터 타입
 **filter**
- `recent`: 최근 스쿱된 항목들을 시간 역순으로 정렬
- `most`: 지정된 기간 동안 가장 많이 스쿱된 항목들을 스쿱 개수 순으로 정렬

**period(filter=most일 때만 사용)**
- `week`: 주간 통계
- `month`: 월간 통계

#### 사용 예시

**최근 스쿱된 채널 조회:**
```bash
curl -X GET "https://[YOUR_PROJECT_REF].supabase.co/functions/v1/charts/channels?filter=recent&limitcount=5" \
  -H "Authorization: Bearer [YOUR_ANON_KEY]"
```

**주간 가장 많이 스쿱된 채널 조회:**
```bash
curl -X GET "https://[YOUR_PROJECT_REF].supabase.co/functions/v1/charts/channels?filter=most&period=week&date=2024-01-15&limitcount=10" \
  -H "Authorization: Bearer [YOUR_ANON_KEY]"
```

**월간 가장 많이 스쿱된 채널 조회:**
```bash
curl -X GET "https://[YOUR_PROJECT_REF].supabase.co/functions/v1/charts/channels?filter=most&period=month&date=2024-01-15&limitcount=20" \
  -H "Authorization: Bearer [YOUR_ANON_KEY]"
```

#### 응답 형식

**최근 스쿱된 채널:**
```json
{
  "RecentChannelResponses": [
    {
      "channel_id": "channel_id_001",
      "channel_name": "채널이름_001"
    },
    {
      "channel_id": "channel_id_002",
      "channel_name": "채널이름_002"
    }
  ],
  "FailedChannelIDs": [
    "채널이름_003",
    "채널이름_004"
  ]
}
```

**가장 많이 스쿱된 채널:**
```json
{
  "MostChannelResponses": [
    {
      "channel_id": "channel_id_001",
      "channel_name": "채널이름_001",
      "sqoop_count": 20
    },
    {
      "channel_id": "channel_id_002",
      "channel_name": "채널이름_002",
      "sqoop_count": 128
    }
  ],
  "FailedChannelIDs": [
    "채널이름_003",
    "채널이름_004"
  ]
}
```

## 필터 타입

### FilterType
- `recent`: 최근 스쿱된 항목들을 시간 역순으로 정렬
- `most`: 지정된 기간 동안 가장 많이 스쿱된 항목들을 스쿱 개수 순으로 정렬

### PeriodType (filter=most일 때만 사용)
- `week`: 주간 통계 (get_weekly_most_sqooped_*_v1 함수 사용)
- `month`: 월간 통계 (MonthlyMostSqooped* 테이블 사용)

## 에러 응답

### 일반적인 에러 코드

| 상태 코드 | 설명 |
|-----------|------|
| 401 | 인증 실패 또는 잘못된 필터 타입 |
| 405 | 지원하지 않는 HTTP 메서드 또는 잘못된 URL 경로 |
| 500 | 서버 내부 오류 |

## 주의사항

1. **인증**: 모든 요청에는 유효한 Authorization 헤더가 필요합니다.
2. **날짜 형식**: `date` 파라미터는 `YYYY-MM-DD` 형식으로 제공해야 합니다.
3. **기본값**: `limitcount`의 기본값은 10이며, 최대값은 데이터베이스 설정에 따라 다를 수 있습니다.
4. **성능**: `most` 필터는 복잡한 집계 쿼리를 수행하므로 응답 시간이 더 오래 걸릴 수 있습니다.