import requests # 1. requests 라이브러리 import

class YoutubeChannelIDGetter:
    BASE_URL = "https://www.googleapis.com/youtube/v3/" # 상수는 대문자로 표기 (PEP 8 스타일 가이드)

    def __init__(self, api_key: str):
        self.api_key = api_key

    # 2. 중복 코드를 처리하기 위한 내부 헬퍼 메서드
    def _fetch_youtube_data(self, endpoint: str, resource_id: str):
        """YouTube API에 요청을 보내고 JSON 데이터를 반환하는 헬퍼 함수"""
        url = f"{self.BASE_URL}{endpoint}"
        params = {
            "part": "snippet",
            "id": resource_id,
            "key": self.api_key
        }
        
        try:
            # 3. requests의 params 인자를 사용해 안전하게 URL 생성
            response = requests.get(url, params=params)
            response.raise_for_status()  # 4. 200번대 상태 코드가 아니면 에러 발생
            
            response_data = response.json()
            
            # API 응답에서 channelId 추출
            if response_data.get('items'):
                return response_data['items'][0]['snippet']['channelId']
            else:
                return None # 검색 결과가 없을 경우 None 반환
                
        except requests.exceptions.RequestException as e:
            print(f"API 요청 중 오류가 발생했습니다: {e}")
            return None
        except ValueError: # JSON 디코딩 에러 처리
            print("잘못된 형식의 API 응답입니다.")
            return None

    def get_channel_id_from_video(self, video_id: str):
        """비디오 ID를 사용하여 채널 ID를 가져옵니다."""
        # 5. 메서드 이름을 snake_case로 변경 (PEP 8)
        return self._fetch_youtube_data("videos", video_id)
    
    def get_channel_id_from_playlist(self, playlist_id: str):
        """플레이리스트 ID를 사용하여 채널 ID를 가져옵니다."""
        # 6. 올바른 'playlists' 엔드포인트 사용
        return self._fetch_youtube_data("playlists", playlist_id)


# --- 사용 예시 ---
if __name__ == '__main__':
    # 여기에 실제 본인의 YouTube API 키를 입력하세요.
    # MY_API_KEY = "AIzaSyAEFJnYCHdHCSYbBwRTLNshZxayWqU1IdM"
    
    # BTS (HYBE LABELS) 영상 ID 및 플레이리스트 ID 예시
    sample_video_id = "gdZLi9oWNZg" # BTS 'Dynamite'
    sample_playlist_id = "PL_Cqw69_m_yzbMVGvQ4tC6gn3lDp_4Qp6" # BTS 'Proof' Live
    
    getter = YoutubeChannelIDGetter(api_key=MY_API_KEY)
    
    # 1. 비디오 ID로 채널 ID 찾기
    channel_id_from_video = getter.get_channel_id_from_video(sample_video_id)
    print(f"비디오 '{sample_video_id}'의 채널 ID: {channel_id_from_video}")
    
    # 2. 플레이리스트 ID로 채널 ID 찾기
    channel_id_from_playlist = getter.get_channel_id_from_playlist(sample_playlist_id)
    print(f"플레이리스트 '{sample_playlist_id}'의 채널 ID: {channel_id_from_playlist}")