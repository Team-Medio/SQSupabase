#!/usr/bin/env python3
"""
SQSupabase PlaylistIDs Edge Functions 로컬 테스트 스크립트

사용법:
1. Supabase 로컬 서버 시작: supabase start
2. 스크립트 실행: python playlistids_functions.py

환경 변수 설정 (선택사항):
- SUPABASE_URL: Supabase URL (기본값: 로컬)
- SUPABASE_ANON_KEY: Supabase Anon Key
"""

import requests
import json
import os
from datetime import datetime, timedelta
from typing import Dict, Any, Optional
import sys

# .env 파일이 있으면 자동으로 로드
try:
    from dotenv import load_dotenv
    load_dotenv(dotenv_path='../.env')
except ImportError:
    # python-dotenv가 설치되지 않은 경우 무시
    pass

class PlaylistIDsFunctionTester:
    def __init__(self):
        # 로컬 Supabase 설정 (기본값)
        self.base_url = os.getenv('SUPABASE_URL', 'http://127.0.0.1:54321/functions/v1')
        
        # 환경 변수에서 토큰 가져오기
        anon_key = os.getenv('SUPABASE_ANON_KEY')

        print(f"SUPABASE_ANON_KEY: {anon_key}")
        if not anon_key:
            print("⚠️  SUPABASE_ANON_KEY 환경 변수가 설정되지 않았습니다.")
            print("   로컬 테스트를 위해서는 다음 명령어로 Supabase를 시작하고 토큰을 확인하세요:")
            print("   supabase start")
            print("   또는 환경 변수를 설정하세요:")
            print("   export SUPABASE_ANON_KEY='your-anon-key'")
            sys.exit(1)
        self.auth_token = f"Bearer {anon_key}"
        
        self.headers = {
            "Authorization": self.auth_token,
            "Content-Type": "application/json"
        }
        
        print(f"🚀 PlaylistIDs Edge Functions Tester 시작")
        print(f"📍 Base URL: {self.base_url}")
        print(f"🔑 Auth Token: {self.auth_token[:20]}...{self.auth_token[-10:]}")
        print("-" * 60)

    def make_request(self, endpoint: str, method: str = "GET", data: Optional[Dict[str, Any]] = None, params: Optional[Dict[str, Any]] = None) -> Optional[Dict[str, Any]]:
        """API 요청을 보내고 응답을 반환합니다."""
        url = f"{self.base_url}{endpoint}"
        
        # GET 요청에 쿼리 파라미터 추가
        if method.upper() == "GET" and params:
            query_string = "&".join([f"{k}={v}" for k, v in params.items()])
            url = f"{url}?{query_string}"
        
        print(f"url: {url}")
        try:
            print(f"📤 {method} {endpoint}")
            
            if method.upper() == "POST":
                response = requests.post(url, headers=self.headers, json=data, timeout=10)
            else:
                response = requests.get(url, headers=self.headers, timeout=10)
            
            print(f"📥 Status: {response.status_code}")
            
            # 응답 내용 출력
            try:
                response_data = response.json()
                print(f"📋 Response: {json.dumps(response_data, indent=2, ensure_ascii=False)}")
                
                if response.status_code == 200:
                    print("✅ 성공!")
                else:
                    print(f"⚠️ 경고: Status {response.status_code}")
                    
                return response_data
            except json.JSONDecodeError:
                print(f"📋 Response (text): {response.text}")
                return {"raw_response": response.text}
                
        except requests.exceptions.ConnectionError:
            print("❌ 연결 실패! Supabase 로컬 서버가 실행 중인지 확인하세요.")
            print("   실행 명령: supabase start")
            return None
        except requests.exceptions.Timeout:
            print("❌ 요청 시간 초과!")
            return None
        except Exception as e:
            print(f"❌ 오류 발생: {e}")
            return None
        finally:
            print("-" * 40)
    
    def test_playlistids_post(self):
        """PlaylistIDs POST 요청 테스트 (플레이리스트 ID 등록)"""
        print("📱 PlaylistIDs POST 테스트 - 플레이리스트 ID 등록")
        endpoint = "/PlaylistIDs"
        return self.make_request(endpoint, "POST", {
            "id": f"PL1234567890_{datetime.now().isoformat()}",
            "date": datetime.now().isoformat(),
            "locale": "KR"
        })
    
    def test_playlistids_recent(self, limit_count: int = 10):
        """PlaylistIDs GET 요청 테스트 - 최근 스쿱된 플레이리스트"""
        print(f"📱 PlaylistIDs GET 테스트 - 최근 스쿱된 플레이리스트 (limit: {limit_count})")
        endpoint = "/PlaylistIDs"
        params = {
            "filter": "recent",
            "limitcount": str(limit_count)
        }
        return self.make_request(endpoint, "GET", params=params)
    
    def test_playlistids_most_week(self, limit_count: int = 10):
        """PlaylistIDs GET 요청 테스트 - 주간 가장 많이 스쿱된 플레이리스트"""
        print(f"📱 PlaylistIDs GET 테스트 - 주간 가장 많이 스쿱된 플레이리스트 (limit: {limit_count})")
        endpoint = "/PlaylistIDs"
        params = {
            "filter": "most",
            "period": "week",
            "date": datetime.now().isoformat(),
            "limitcount": str(limit_count)
        }
        return self.make_request(endpoint, "GET", params=params)
    
    def test_playlistids_most_month(self, limit_count: int = 10):
        """PlaylistIDs GET 요청 테스트 - 월간 가장 많이 스쿱된 플레이리스트"""
        print(f"📱 PlaylistIDs GET 테스트 - 월간 가장 많이 스쿱된 플레이리스트 (limit: {limit_count})")
        endpoint = "/PlaylistIDs"
        params = {
            "filter": "most",
            "period": "month",
            "date": datetime.now().isoformat(),
            "limitcount": str(limit_count)
        }
        return self.make_request(endpoint, "GET", params=params)

    def run_all_tests(self):
        """모든 테스트 실행"""
        print("🧪 모든 PlaylistIDs Edge Functions 테스트 시작\n")
        
        results = {}
        
        # POST 테스트
        results["POST - 플레이리스트 ID 등록"] = self.test_playlistids_post()
        
        # GET 테스트들
        results["GET - 최근 스쿱된 플레이리스트"] = self.test_playlistids_recent(5)
        results["GET - 주간 가장 많이 스쿱된 플레이리스트"] = self.test_playlistids_most_week(5)
        results["GET - 월간 가장 많이 스쿱된 플레이리스트"] = self.test_playlistids_most_month(5)
        
        print("✨ 모든 테스트 완료!")
        print("\n📊 테스트 결과 요약:")
        
        success_count = 0
        total_count = 0
        
        for test_name, result in results.items():
            total_count += 1
            if result is not None:
                success_count += 1
                print(f"  ✅ {test_name}: 성공")
            else:
                print(f"  ❌ {test_name}: 실패")
        
        print(f"\n🎯 성공률: {success_count}/{total_count} ({success_count/total_count*100:.1f}%)")
        
        return results

    def interactive_test(self):
        """대화형 테스트 모드"""
        print("\n🎮 대화형 테스트 모드")
        print("사용 가능한 명령어:")
        print("  1. post      - 플레이리스트 ID 등록 (POST)")
        print("  2. recent    - 최근 스쿱된 플레이리스트 (GET)")
        print("  3. week      - 주간 가장 많이 스쿱된 플레이리스트 (GET)")
        print("  4. month     - 월간 가장 많이 스쿱된 플레이리스트 (GET)")
        print("  5. all       - 모든 테스트 실행")
        print("  quit/q/exit  - 종료")
        
        while True:
            try:
                command = input("\n명령어를 입력하세요: ").strip().lower()
                
                if command in ['quit', 'q', 'exit']:
                    print("👋 테스트 종료!")
                    break
                elif command == '1' or command == 'post':
                    self.test_playlistids_post()
                elif command == '2' or command == 'recent':
                    limit = input("개수 제한 (기본값: 10): ").strip()
                    limit_count = int(limit) if limit.isdigit() else 10
                    self.test_playlistids_recent(limit_count)
                elif command == '3' or command == 'week':
                    limit = input("개수 제한 (기본값: 10): ").strip()
                    limit_count = int(limit) if limit.isdigit() else 10
                    self.test_playlistids_most_week(limit_count)
                elif command == '4' or command == 'month':
                    limit = input("개수 제한 (기본값: 10): ").strip()
                    limit_count = int(limit) if limit.isdigit() else 10
                    self.test_playlistids_most_month(limit_count)
                elif command == '5' or command == 'all':
                    self.run_all_tests()
                else:
                    print("❓ 알 수 없는 명령어입니다.")
                    
            except KeyboardInterrupt:
                print("\n\n👋 테스트 종료!")
                break
            except EOFError:
                print("\n\n👋 테스트 종료!")
                break

def main():
    """메인 함수"""
    print("🎯 SQSupabase PlaylistIDs Edge Functions 테스터")
    print("=" * 60)
    
    tester = PlaylistIDsFunctionTester()
    tester.interactive_test()

if __name__ == "__main__":
    main()
