# Channels API

## 개요
Channels Edge Function은 YouTube 채널의 플레이리스트 정보를 조회하는 API입니다.

## Base URL
- Production: `https://your-project.supabase.co/functions/v1/channels`

## 인증
모든 요청에는 Authorization 헤더가 필요합니다.
```
Authorization: Bearer YOUR_SUPABASE_ANON_KEY
```

## 엔드포인트

### 1. 채널 플레이리스트 조회
특정 채널이 가지고 있는 플레이리스트들을 조회합니다. <br/>
**조회 기준:** 가장 최근 스쿱한 순서

**Endpoint:** `GET /playlists`

**Query Parameters:**
- `channelId` (string, required): YouTube 채널 ID
- `limitcount` (number, optional): 조회할 플레이리스트 수 (기본값: 10)

**Request Example:**
```bash
curl -X GET 'http://127.0.0.1:54321/functions/v1/channels/playlists?channelId=UC_x5XG1OV2P6uZZ5FSM9Ttw&limitcount=5' \
  --header 'Authorization: Bearer YOUR_SUPABASE_ANON_KEY' \
  --header 'Content-Type: application/json'
```

**Response Example:**
```json
{
  "playlistHeads": [
    {
      "id": "PLrAXtmRdnEQy4Atom665uJjjHfXlrxg2m",
      "originURL": "https://www.youtube.com/playlist?list=PLrAXtmRdnEQy4Atom665uJjjHfXlrxg2m",
      "insertedDate": "2023-01-15T10:30:00.000Z",
      "isShazamed": true,
      "thumbnailURL": "https://i.ytimg.com/vi/abc123/hqdefault.jpg",
      "title": "Best Music Playlist",
      "channel": {
        "id": "UC_x5XG1OV2P6uZZ5FSM9Ttw",
        "name": "Music Channel",
        "subscribers": 150000,
        "thumbnailURLString": "https://yt3.ggpht.com/channel_thumb.jpg"
      },
      "ytPlaylistType": "Official"
    }
  ],
  "failedPlaylistIds": []
}
```
- 정보 조회에 성공한 데이터: *playlistHeads*
- 정보 조회에 실패한 데이터: *failedPlaylistIds* id만 반환합니다.


### 2. 채널 플레이리스트 ID 목록 조회
특정 채널의 플레이리스트 ID들만 조회합니다.

**Endpoint:** `GET /playlists/id`

**Query Parameters:**
- `channelId` (string, required): YouTube 채널 ID
- `limitcount` (number, optional): 조회할 플레이리스트 수 (기본값: 10)

**Request Example:**
```bash
curl -X GET 'http://127.0.0.1:54321/functions/v1/channels/playlists/id?channelId=UC_x5XG1OV2P6uZZ5FSM9Ttw&limitcount=5' \
  --header 'Authorization: Bearer YOUR_SUPABASE_ANON_KEY' \
  --header 'Content-Type: application/json'
```

**Response Example:**
```json
[
  "PLrAXtmRdnEQy4Atom665uJjjHfXlrxg2m",
  "PLrAXtmRdnEQy4Atom665uJjjHfXlrxg3n",
  "PLrAXtmRdnEQy4Atom665uJjjHfXlrxg4o"
]
```

## 데이터 모델

### YTChannelInfo
```typescript
type YTChannelInfo = {
    id: string;                    // 채널 ID
    name: string;                  // 채널 이름
    subscribers: number;           // 구독자 수 inteager
    thumbnailURLString: string;    // 채널 썸네일 URL
}
```

### YTPlaylistHead
```typescript
type YTPlaylistHead = {
    id: string;                    // 플레이리스트 ID
    originURL: string;             // 플레이리스트 원본 URL
    insertedDate: Date;            // 삽입 날짜
    isShazamed: boolean;           // Shazam 처리 여부
    thumbnailURL: string;          // 플레이리스트 썸네일 URL
    title: string;                 // 플레이리스트 제목
    channel: YTChannelInfo;        // 채널 정보
    ytPlaylistType: string;        // 플레이리스트 타입 ("Official" or "Video")
}
```

## 에러 응답

### 401 Unauthorized
```json
"Authorization error"
```

### 404 Not Found
```json
"Don't exsit playlist"
```

### 405 Method Not Allowed
```json
"req.method Error [URL]"
```
```json
"urlPath Error [URL]"
```

## 사용 예시

### JavaScript/TypeScript
```javascript
const channelId = 'UC_x5XG1OV2P6uZZ5FSM9Ttw';
const limitCount = 10;

// 플레이리스트 상세 정보 조회
const response = await fetch(`/functions/v1/channels/playlists?channelId=${channelId}&limitcount=${limitCount}`, {
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
    'Content-Type': 'application/json'
  }
});

const data = await response.json();
console.log(data.playlistHeads);

// 플레이리스트 ID만 조회
const idsResponse = await fetch(`/functions/v1/channels/playlists/id?channelId=${channelId}&limitcount=${limitCount}`, {
  method: 'GET',
  headers: {
    'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
    'Content-Type': 'application/json'
  }
});

const playlistIds = await idsResponse.json();
console.log(playlistIds);
```

### Python
```python
import requests

SUPABASE_ANON_KEY = "your_supabase_anon_key"
BASE_URL = "http://127.0.0.1:54321/functions/v1/channels"

headers = {
    "Authorization": f"Bearer {SUPABASE_ANON_KEY}",
    "Content-Type": "application/json"
}

# 플레이리스트 상세 정보 조회
channel_id = "UC_x5XG1OV2P6uZZ5FSM9Ttw"
limit_count = 10

response = requests.get(
    f"{BASE_URL}/playlists",
    params={"channelId": channel_id, "limitcount": limit_count},
    headers=headers
)

if response.status_code == 200:
    data = response.json()
    print(data["playlistHeads"])
else:
    print(f"Error: {response.text}")
```

## 참고사항
- `limitcount` 파라미터를 생략하면 기본적으로 10개의 결과를 반환합니다
- 존재하지 않는 플레이리스트 ID는 `failedPlaylistIds` 배열에 포함됩니다
- 채널이 존재하지 않는 경우 404 에러를 반환합니다

### 연관 데이터 및 자료
1. RPC Function: `getchannelplaylistids`
2. Table: `ChartData`
