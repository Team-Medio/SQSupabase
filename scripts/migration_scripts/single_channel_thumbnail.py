import os
import requests
from dotenv import load_dotenv

load_dotenv()

def get_channel_thumbnail(channel_id: str):
    """
    단일 유튜브 채널 ID를 썸네일 URL로 변환
    
    사용 예시:
    thumbnail_url = get_channel_thumbnail("UCzsjN_osDqCaM6roxBJv44Q")
    print(thumbnail_url)
    """
    youtube_api_key = os.getenv("YOUTUBE_API_KEY")
    
    try:
        url = f"https://www.googleapis.com/youtube/v3/channels?part=snippet&id={channel_id}&key={youtube_api_key}"
        response = requests.get(url)
        response.raise_for_status()
        
        data = response.json()
        if not data.get("items"):
            return None
            
        # 다양한 크기 옵션:
        # default: 88x88
        # medium: 240x240  
        # high: 800x800
        return data["items"][0]["snippet"]["thumbnails"]["high"]["url"]
        
    except Exception as e:
        print(f"오류 발생: {e}")
        return None

# 테스트
if __name__ == "__main__":
    # failedList.json의 첫 번째 채널로 테스트
    test_channel_id = "UCzsjN_osDqCaM6roxBJv44Q"
    thumbnail = get_channel_thumbnail(test_channel_id)
    print(f"채널 ID: {test_channel_id}")
    print(f"썸네일 URL: {thumbnail}")
