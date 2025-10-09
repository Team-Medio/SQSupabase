import os
import sys
import time
import json
import requests
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
            data = self.supabase.table("send_to_playlist_date").select().gte("sqooped_date", start_date).lte("sqooped_date", end_date).execute()
            print(f"추출된 데이터 개수: {len(data.data) if data.data else 0}")
            return data
        except Exception as e:
            print(f"데이터 추출 실패: {e}")
            # 테이블 존재 여부 확인을 위한 간단한 쿼리 시도
            try:
                test_data = self.supabase.table("send_to_playlist_date").select("*").limit(1).execute()
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
            ("2025-09-01", "2025-09-30", "2025-09"),
            ("2025-08-01", "2025-08-31", "2025-08")
            ]
    
    def convertMonths(self, months: list[int]):
        searchMonths = []
        for month in months:
            for month_data in self.months:
                if month_data[2].endswith(f"-{month:02d}"):
                    searchMonths.append(month_data)
                    break
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
# sendToPlaylistDateToJSONConverter.convertMonths([9, 8])
# marchDatas = sendToPlaylistDateToJSONConverter.getSendToPlaylistData(3)

# 결론: 현재 코드에서는 하나의 비디오 ID만 요청하므로 items[0]으로 첫 번째(유일한) 결과를 가져오는 것이 맞습니다. 배열 구조는 YouTube API의 설계 철학 때문이지, 실제로 여러 비디오가 반환되기 때문은 아닙니다.
class YoutubeChannelIDGetter:
    baseURL = "https://www.googleapis.com/youtube/v3/"
    video = "videos"
    playlists = "playlists"
    channels = "channels"
    apiKey = ""

    def __init__(self, apiKey: str):
        self.baseURL = "https://www.googleapis.com/youtube/v3/"
        self.video = "videos"
        self.playlists = "playlists"
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
    
    def getPlaylistInfoChannelID(self, endpoint: str,playlistId: str):
        baseURL = f"{self.baseURL}{endpoint}"
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
    


youtubeChannelIDGetter = YoutubeChannelIDGetter(youtube_api_key)
def migration_data_sendto_playlist_to_chart_data(months: list[int]):
    supabase = create_client(os.getenv("SUPABASE_API"), os.getenv("SUPABASE_ANON_KEY"))
    for month in months:
        filename = f"./SendToPlaylisMonthlyData/migration_data_2025-0{month}.json"
        with open(filename, 'r', encoding='utf-8') as f:
            data = json.load(f)
        chart_datas = []
        failedPlaylists = []
        for item in data:
            print(f"Processing playlist ID: {item['id']}")
            video_channel_id = youtubeChannelIDGetter.getPlaylistInfoChannelID("videos", item["id"])
            if video_channel_id:
                # chart_data 테이블 스키마에 맞게 데이터 변환
                chart_data_item = {
                    "id": item["id"],
                    "sqooped_date": item["sqooped_date"],
                    "watch_system": item["watch_system"],
                    "country_code": item.get("country_code"),  # null일 수 있음
                    "channel_id": video_channel_id,
                    "sqoop_count": item["sqoop_count"]
                }
                chart_datas.append(chart_data_item)
            else:
                playlist_channel_id = youtubeChannelIDGetter.getPlaylistInfoChannelID("playlists", item["id"])
                if playlist_channel_id:
                    chart_data_item = {
                        "id": item["id"],
                        "sqooped_date": item["sqooped_date"],
                        "watch_system": item["watch_system"],
                        "country_code": item.get("country_code"),  # null일 수 있음
                        "channel_id": playlist_channel_id,
                        "sqoop_count": item["sqoop_count"]
                    }
                    chart_datas.append(chart_data_item)
                else:
                    print(f"Failed to get channel_id for video: {item['id']}")
                    print(f"Failed to get channel_id for playlist: {item['id']}")
                    failedPlaylists.append(item["id"])

        with open(f"./FailedPlaylists/failedPlaylists_{month}.json", 'w', encoding='utf-8') as f:
            json.dump(failedPlaylists, f, ensure_ascii=False, indent=2, default=str)
        if chart_datas:
            try:
                result = supabase.table("chart_data").insert(chart_datas).execute()
                print(f"Successfully inserted {len(chart_datas)} records for {month} month data")
            except Exception as e:
                print(f"Error inserting data for month {month}: {e}")
        else:
            print(f"No valid data to insert for month {month}")
migration_data_sendto_playlist_to_chart_data([8])

# youtubeEndpoint = YoutubeEndpoint(youtube_api_key)

# print(youtubeEndpoint.getVideoInfoUrl("PrqwxkBB0DA"))
# 응답에서 channelId 추출하는 방법:

