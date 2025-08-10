# Edge Functions 테스트 가이드

## 사전 준비

### 1. Python 의존성 설치
```bash
pip install -r requirements.txt
```

### 2. 환경 변수 설정
```bash
# env.example을 참고하여 .env 파일 생성
cp env.example .env

# 또는 직접 환경 변수 설정
export SUPABASE_URL="http://127.0.0.1:54321/functions/v1"
export SUPABASE_ANON_KEY="your-anon-key"
```

### 3. Supabase 로컬 서버 시작
```bash
# 프로젝트 루트에서 실행
supabase start
```

서버가 시작되면 다음과 같은 정보가 출력됩니다:
- API URL: http://localhost:54321
- DB URL: postgresql://postgres:postgres@localhost:54322/postgres
- Studio URL: http://localhost:54323

## 테스트 실행 방법

### 1. 대화형 모드 (기본)
```bash
python test_edge_functions.py
```

### 2. 모든 테스트 자동 실행
```bash
python test_edge_functions.py all
```

### 3. 특정 테스트만 실행
```bash
# PlaylistIDs Recent 테스트
python test_edge_functions.py recent

# PlaylistIDs Most 테스트  
python test_edge_functions.py most

# PlaylistIDs POST 테스트
python test_edge_functions.py post

# VersionManager 테스트
python test_edge_functions.py version

# 기본 테스트 함수
python test_edge_functions.py test
```

## 실제 클라우드 DB 연결 테스트

### 환경 변수 설정
```bash
# Linux/Mac
export SUPABASE_URL="https://your-project-id.supabase.co/functions/v1"
export SUPABASE_ANON_KEY="your-actual-anon-key"

# Windows
set SUPABASE_URL=https://your-project-id.supabase.co/functions/v1
set SUPABASE_ANON_KEY=your-actual-anon-key
```

### .env 파일 사용 (권장)
```bash
# env.example을 복사해서 .env 파일 생성
cp env.example .env

# .env 파일을 편집하여 실제 값으로 변경
# SUPABASE_URL=https://your-project-id.supabase.co/functions/v1
# SUPABASE_ANON_KEY=your-actual-anon-key
```

## 테스트 함수 설명

### PlaylistIDs 함수
- **Recent**: 최근 접근한 플레이리스트 ID 조회
- **Most**: 특정 기간 동안 가장 많이 접근한 플레이리스트 조회  
- **POST**: 새로운 플레이리스트 접근 기록 추가

### VersionManager 함수
- iOS 앱 버전 상태 확인

### Test 함수
- 기본적인 GET/POST 요청 테스트

## 문제 해결

### 연결 실패 시
1. Supabase 로컬 서버가 실행 중인지 확인
2. 포트 54321이 사용 중인지 확인
3. 방화벽 설정 확인

### 인증 오류 시
1. SUPABASE_ANON_KEY 환경 변수 확인
2. 토큰 형식 확인 (Bearer 접두사 포함)
3. 토큰 만료 여부 확인

### 함수 오류 시
1. Edge Functions이 올바르게 배포되었는지 확인
2. 함수 로그 확인: `supabase logs --type functions`
3. 데이터베이스 연결 상태 확인
