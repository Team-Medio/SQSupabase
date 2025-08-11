import os
import sys
import time
import json
import requests
import pandas as pd
import numpy as np
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

# SendToPlaylist 테이블에서 ChartData 테이블로 데이터 이동
# 1. supabase에서 모든 데이터 추출이 가능하게 하기
# 2. 추출한 데이터를 일별로 JSON 파일로 저장 -> SendToPlaylist 테이블 구조 그대로
# 3. 각 날짜마다 만든 파일들을 추출하여 구글 API를 이용해 채널 ID를 가져옴
# 4. 채널 ID를 가져온 후 채널 ID를 이용해 ChartData 테이블에 생성 및 Upsert 처리
youtube_api_key = os.getenv("YOUTUBE_API_KEY")
class SendToPlaylistToChartData:
    def __init__(self):
        # 환경변수 검증 (보안상 실제 값은 출력하지 않음)
        api = os.getenv("SUPABASE_API")
        key = os.getenv("SUPABASE_ANON_KEY")
        youtube_api_key = os.getenv("YOUTUBE_API_KEY")
        
        if not api or not key:
            raise ValueError("SUPABASE_URL 또는 SUPABASE_ANON_KEY 환경변수가 설정되지 않았습니다.")
        
        print(f"Supabase URL 설정됨: {api[:20]}...")
        print(f"Supabase Key 설정됨: {key[:10]}...")
        print(f"Youtube API Key 설정됨: {youtube_api_key[:10]}...")
        try:
            self.supabase = create_client(api, key)
            self.youtube_api_key = youtube_api_key
        except Exception as e:
            raise Exception(f"Supabase 클라이언트 생성 실패: {e}")

    def extract_data(self, start_date, end_date):
        try:
            print(f"데이터 추출 시도: {start_date} ~ {end_date}")
            data = self.supabase.table("SendToPlaylistDate").select().gte("sqooped_date", start_date).lte("sqooped_date", end_date).execute()
            print(f"추출된 데이터 개수: {len(data.data) if data.data else 0}")
            return data
        except Exception as e:
            print(f"데이터 추출 실패: {e}")
            # 테이블 존재 여부 확인을 위한 간단한 쿼리 시도
            try:
                test_data = self.supabase.table("SendToPlaylistDate").select("*").limit(1).execute()
                print("테이블은 존재하지만 날짜 조건에 맞는 데이터가 없거나 다른 문제가 있습니다.")
            except Exception as table_error:
                print(f"테이블 접근 실패: {table_error}")
            raise e

    def channel_id_to_youtube_url(self, channel_id):
        pass




class SendToPlaylistDateToJSONConverter:
    def __init__(self, sendToPlaylistToChartData: SendToPlaylistToChartData):
        self.sendToPlaylistToChartData = sendToPlaylistToChartData
        self.months = [
            ("2025-01-01", "2025-01-31", "2025-01"),
            ("2025-02-01", "2025-02-28", "2025-02"),
            ("2025-03-01", "2025-03-31", "2025-03"),
            ("2025-04-01", "2025-04-30", "2025-04"),
            ("2025-05-01", "2025-05-31", "2025-05"),
            ("2025-06-01", "2025-06-30", "2025-06"),
            ("2025-07-01", "2025-07-31", "2025-07"),
            ("2025-08-01", "2025-08-31", "2025-08")
            ]
    
    def convertMonths(self, months: list[int]):
        searchMonths = [self.months[v-1] for v in months]
        for start_date, end_date, month_label in searchMonths:
            print(f"\n=== {month_label} 데이터 처리 중 ===")
            self._saveMonth(start_date, end_date, month_label)

    def convertMonth(self, month: int):
        searchMonth = self.months[month-1]
        self._saveMonth(searchMonth[0], searchMonth[1], searchMonth[2])

    def _saveMonth(self, start_date: str, end_date: str, month_label: str):
        data = self.sendToPlaylistToChartData.extract_data(start_date, end_date)
        if data.data:
            filename = f"./SendToPlaylisMonthlyData/migration_data_{month_label}.json"
            with open(filename, 'w', encoding='utf-8') as f:
                json.dump(data.data, f, ensure_ascii=False, indent=2, default=str)
                print(f"{filename} 파일로 저장 완료 (데이터 개수: {len(data.data)})")
        else:
            print(f"{month_label}: 저장할 데이터가 없습니다.")

    def getSendToPlaylistData(self, month: int):
        searchMonth = self.months[month-1]
        filename = f"./SendToPlaylisMonthlyData/migration_data_{searchMonth[2]}.json"
        with open(filename, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return data

class ChartDataToJSONConverter:
    def __init__(self, sendToPlaylistToChartData: SendToPlaylistToChartData):
        self.sendToPlaylistToChartData = sendToPlaylistToChartData
    
    def convert(self, data: list[dict]):
        pass

# sendToPlaylistToChartData = SendToPlaylistToChartData()

# sendToPlaylistToChartData = SendToPlaylistToChartData()
# sendToPlaylistDateToJSONConverter = SendToPlaylistDateToJSONConverter(sendToPlaylistToChartData)
# marchDatas = sendToPlaylistDateToJSONConverter.getSendToPlaylistData(3)

# 결론: 현재 코드에서는 하나의 비디오 ID만 요청하므로 items[0]으로 첫 번째(유일한) 결과를 가져오는 것이 맞습니다. 배열 구조는 YouTube API의 설계 철학 때문이지, 실제로 여러 비디오가 반환되기 때문은 아닙니다.
class YoutubeChannelIDGetter:
    baseURL = "https://www.googleapis.com/youtube/v3/"
    video = "videos"
    channels = "channels"
    apiKey = ""

    def __init__(self, apiKey: str):
        self.baseURL = "https://www.googleapis.com/youtube/v3/"
        self.video = "videos"
        self.channels = "channels"
        self.apiKey = apiKey

    def getVideoInfoChannelID(self, videoId: str):
        baseURL = f"{self.baseURL}{self.video}"
        params = {
            "part": "snippet",
            "id": videoId,
            "key": self.apiKey
        }
        query_string = "&".join([f"{key}={value}" for key, value in params.items()])
        url = f"{baseURL}?{query_string}"
        
        response = requests.get(url)
        response_data = response.json()
        # channelId 추출:
        if response_data.get('items') and len(response_data['items']) > 0:
            channel_id = response_data['items'][0]['snippet']['channelId']
            return channel_id
        else:
            return None
    
    def getPlaylistInfoChannelID(self, playlistId: str):
        baseURL = f"{self.baseURL}{self.channels}"
        params = {
            "part": "snippet",
            "id": playlistId,
            "key": self.apiKey
        }
        query_string = "&".join([f"{key}={value}" for key, value in params.items()])
        url = f"{baseURL}?{query_string}"
        response = requests.get(url)
        response_data = response.json()
        # channelId 추출:
        if response_data.get('items') and len(response_data['items']) > 0:
            channel_id = response_data['items'][0]['snippet']['channelId']
            return channel_id
        else:
            return None
    

# youtubeEndpoint = YoutubeEndpoint(youtube_api_key)

# print(youtubeEndpoint.getVideoInfoUrl("PrqwxkBB0DA"))
# 응답에서 channelId 추출하는 방법:

