# Sqoop API
스쿱의 플레이리스트 관련 데이터를 수집 및 조회를 위한 API 입니다. <br/>

SQSupabase는 YouTube 플레이리스트 및 채널 데이터를 관리하고 차트 기능을 제공하는 Supabase Edge Functions 기반의 백엔드 시스템입니다.

## 최소 사용 방법
1. Sqoop Supabase URL 인가 후 적용
2. Supabase Anon Key 인가 후 Authorization 적용

```bash
curl -X {METHOD} "{SUPABASE URL}/..." \
  -H "Authorization: Bearer {ANON KEY}" \
  -H "Content-Type: application/json"
```

### 🏗️ 주요 구성 요소

- **Supabase Edge Functions**: TypeScript/Deno 기반 서버리스 함수
- **PostgreSQL Database**: 데이터 저장 및 관리
- **Python Test Scripts**: API 테스트 및 검증
- **Migration Scripts**: 데이터 마이그레이션 도구

## API 업데이트 요약
자세한 내용은 docs 폴더에 존재함
### VER 1.0
> Legacy API 결정
1. PlaylistIDs
> 초기 API 생성
1. Channels | 2. Charts | 3. Sqoops