import os
from supabase import create_client, Client

# .env 파일이 있으면 자동으로 로드
try:
    from dotenv import load_dotenv
    load_dotenv(dotenv_path='.env')
    print("python-dotenv가 설치되었습니다.")
except ImportError:
    print("python-dotenv가 설치되지 않았습니다.")
    # python-dotenv가 설치되지 않은 경우 무시
    pass

url: str = "https://bgajlqqbebcnltzbarur.supabase.co"
key: str = os.getenv('SUPABASE_ANON_KEY')
print("url: ", url)
print("key: ", key)
supabase: Client = create_client(url, key)

response = supabase.rpc(
    "getheads",
    {
        "ids": [
            "LTZ-Oe6yptQ", "XJcQH6SCxx4", "RUtKXAP16Ss", "0eCKt36zp_A", "ThREQCkjvxQ"
        ]
    }
).execute()

print(response.data)
print(len(response.data))