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
for i in [9, 8]:
    with open(f"./SendToPlaylisMonthlyData/migration_data_2025_9{i}.json", "r") as f:
        data = json.load(f)
        supabase.table("chart_data").insert(data).execute()
        print(f"inserted {i} month data")