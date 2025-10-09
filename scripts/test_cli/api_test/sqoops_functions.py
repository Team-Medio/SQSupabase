#!/usr/bin/env python3
"""
SQSupabase Edge Functions 로컬 테스트 스크립트

사용법:
1. Supabase 로컬 서버 시작: supabase start
2. 스크립트 실행: python test_edge_functions.py

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

class EdgeFunctionTester:
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
        
        print(f"🚀 Edge Functions Tester 시작")
        print(f"📍 Base URL: {self.base_url}")
        print(f"🔑 Auth Token: {self.auth_token[:20]}...{self.auth_token[-10:]}")
        print("-" * 60)

    def make_request(self, endpoint: str, method: str = "GET", data: Optional[Dict[str, Any]] = None) -> Optional[Dict[str, Any]]:
        """API 요청을 보내고 응답을 반환합니다."""
        url = f"{self.base_url}{endpoint}"
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
    
    def test_sqoops_log(self):
        """sqoops post 로컬 값 보내기 테스트"""
        print("📱 sqoops 값 보내기 테스트")
        endpoint = "/sqoops/log"
        return self.make_request(endpoint, "POST", {
            "id": f"1234567890_{datetime.now().isoformat()}",
            "date": datetime.now().isoformat(),
            "locale": "KR",
            "channelID": f"1234567890_{datetime.now().isoformat()}"
        })
    

    def run_all_tests(self):
        """모든 테스트 실행"""
        print("🧪 모든 Edge Functions 테스트 시작\n")
        
        results = {}
        
        
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
        print("  1. recent    - PlaylistIDs Recent 테스트")
        
        while True:
            try:
                command = input("\n명령어를 입력하세요: ").strip().lower()
                
                if command in ['quit', 'q', 'exit']:
                    print("👋 테스트 종료!")
                    break
                elif command == '1' or command == 'recent':
                    self.test_sqoops_log()
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
    print("🎯 SQSupabase Edge Functions 테스터")
    print("=" * 60)
    
    tester = EdgeFunctionTester()
    tester.interactive_test()

if __name__ == "__main__":
    main()
