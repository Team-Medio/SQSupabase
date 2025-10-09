## PlaylistIDs Edge Function API 관리

### 2025-08-10
#### index.ts 관리

1. SUPABASE 환경 변수에 따른 Authorization 처리
2. GET / POST에 따른 데이터 저장 처리

### Get 처리
- 필터 타입에 따른 RECENT / MOST 플레이리스트 차트의 플리 ID 반환
##### 주요 RPC Function

1. 인기 차트 플레이리스트 봔환
- 월간 차트: `MonthlyMostSqoopedPlaylists`
- 주간 차트: `get_weekly_most_sqooped_playlists_v1`

2. 주간 차트 플레이리스트 반환
- Legacy (메서드 명 변경 이전에 사용하던 것, 유저 데이터 보관을 위해 사용함) : `PlaylistHeadAccessDate`
  - 파라미터 -> limit(Int)
- Recent (메서드 명 변경 이후에 사용할 것, 유저 데이터를 모으기 위해 기존에 LegacyVersion을 사용함): `RecentSqoopedPlaylists`
  - 파라미터 -> limit(Int)

### Post 처리
#### 주요 RPC Function
- `insert_sqooped_log`
  - 파라미터 -> playlist_id (Identifable), now_date (Date), country_code (String)


1. 마이그레이션 처리를 어떻게 할 것인가?
우선 유튜브에서 채널 아이디 추출할 수 있는 메서드를 만들자
