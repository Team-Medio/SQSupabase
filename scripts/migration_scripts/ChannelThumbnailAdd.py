import os
from dotenv import load_dotenv
from supabase import create_client, Client
import requests
import json

load_dotenv()
youtube_api_key = os.getenv("YOUTUBE_API_KEY")

class ChannelThumbnailAdd:
    def __init__(self):
        self.youtube_api_key = youtube_api_key
        self.supabase = create_client(os.getenv("SUPABASE_API"), os.getenv("SUPABASE_ANON_KEY"))
        self.failedList = []

    def add_channel_thumbnail(self):
        channel_info = self.supabase.table("YTChannelInfo").select("*").eq("thumbnailURLString", "").execute()
        for channel in channel_info.data:
            channel_id = channel["id"]
            try:
                channel_thumbnail = self.get_channel_thumbnail(channel_id)
                self.supabase.table("YTChannelInfo").update({"thumbnailURLString": channel_thumbnail}).eq("id", channel_id).execute()
                print(f"Channel {channel_id} thumbnail added")
            except Exception as e:
                self.failedList.append({
                    "channel_id": channel_id,
                    "name": channel["name"],
                })
                print(f"Channel {channel_id} thumbnail failed: {e}")
        print(f"Failed List: {self.failedList}")

    def get_channel_thumbnail(self, channel_id: str):
        """
        유튜브 API를 통해 채널의 프로필 이미지(썸네일)를 가져옵니다.
        
        Args:
            channel_id (str): 유튜브 채널 ID
            
        Returns:
            str: 채널 프로필 이미지 URL
            
        Raises:
            Exception: API 호출 실패 또는 응답 데이터 파싱 실패시
        """
        try:
            url = f"https://www.googleapis.com/youtube/v3/channels?part=snippet&id={channel_id}&key={self.youtube_api_key}"
            response = requests.get(url)
            response.raise_for_status()  # HTTP 에러 체크
            
            data = response.json()
            if not data.get("items"):
                raise Exception(f"채널 ID {channel_id}에 대한 데이터를 찾을 수 없습니다.")
                
            # default 크기의 썸네일 URL 반환 (88x88 픽셀)
            return data["items"][0]["snippet"]["thumbnails"]["default"]["url"]
            
        except requests.exceptions.RequestException as e:
            raise Exception(f"API 호출 실패: {str(e)}")
        except (KeyError, IndexError) as e:
            raise Exception(f"응답 데이터 파싱 실패: {str(e)}")

if __name__ == "__main__":
    channel_thumbnail_add = ChannelThumbnailAdd()
    channel_thumbnail_add.add_channel_thumbnail()
    with open("failedList.json", "w") as f:
        json.dump(channel_thumbnail_add.failedList, f)

