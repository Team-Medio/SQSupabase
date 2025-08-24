import os
import json
from dotenv import load_dotenv
import requests

load_dotenv()

class ProcessFailedChannels:
    def __init__(self):
        self.youtube_api_key = os.getenv("YOUTUBE_API_KEY")
        
    def get_channel_thumbnail(self, channel_id: str):
        """
        유튜브 채널 ID를 썸네일 URL로 변환
        
        Args:
            channel_id (str): 유튜브 채널 ID
            
        Returns:
            dict: 다양한 크기의 썸네일 URL들
        """
        try:
            url = f"https://www.googleapis.com/youtube/v3/channels?part=snippet&id={channel_id}&key={self.youtube_api_key}"
            response = requests.get(url)
            response.raise_for_status()
            
            data = response.json()
            if not data.get("items"):
                raise Exception(f"채널 ID {channel_id}에 대한 데이터를 찾을 수 없습니다.")
            
            thumbnails = data["items"][0]["snippet"]["thumbnails"]
            return {
                "channel_id": channel_id,
                "name": data["items"][0]["snippet"]["title"],
                "thumbnails": {
                    "default": thumbnails.get("default", {}).get("url", ""),
                    "medium": thumbnails.get("medium", {}).get("url", ""),
                    "high": thumbnails.get("high", {}).get("url", "")
                }
            }
            
        except Exception as e:
            return {
                "channel_id": channel_id,
                "error": str(e)
            }
    
    def process_failed_list(self):
        """failedList.json의 채널들을 처리하여 썸네일 정보를 가져옵니다."""
        
        # failedList.json 읽기
        with open("failedList.json", "r") as f:
            failed_channels = json.load(f)
        
        results = []
        
        for channel in failed_channels:
            channel_id = channel["channel_id"]
            print(f"Processing channel: {channel_id}")
            
            result = self.get_channel_thumbnail(channel_id)
            results.append(result)
        
        # 결과를 JSON 파일로 저장
        with open("channel_thumbnails_result.json", "w", encoding="utf-8") as f:
            json.dump(results, f, ensure_ascii=False, indent=2)
        
        print(f"처리 완료! {len(results)}개 채널의 썸네일 정보를 가져왔습니다.")
        return results

if __name__ == "__main__":
    processor = ProcessFailedChannels()
    processor.process_failed_list()
