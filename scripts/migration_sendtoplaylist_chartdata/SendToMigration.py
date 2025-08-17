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

api = os.getenv("SUPABASE_API")
key = os.getenv("SUPABASE_ANON_KEY")
supabase = create_client(api, key)
for i in [8, 7, 6, 5, 4, 3]:
    with open(f"./SendToPlaylisMonthlyData/migration_data_2025-0{i}.json", "r") as f:
        data = json.load(f)
        items = []
        for item in data:
            item["watch_system"] = item.pop("watchSystem")
            items.append(item)
        supabase.table("send_to_playlist_date").insert(items).execute()
        print(f"inserted {i} month data")