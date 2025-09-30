from __future__ import annotations
import os
from typing import Optional
from supabase import create_client, Client
from .config import SUPABASE_URL, SUPABASE_KEY, SUPABASE_BUCKET

_client: Optional[Client] = None

def get_client() -> Client:
    global _client
    if _client is None:
        if not SUPABASE_URL or not SUPABASE_KEY:
            raise RuntimeError("Supabase credentials missing. Set SUPABASE_URL and SUPABASE_KEY in .env")
        _client = create_client(SUPABASE_URL, SUPABASE_KEY)
    return _client

def download_bytes(path: str) -> bytes:
    sb = get_client()
    return sb.storage.from_(SUPABASE_BUCKET).download(path)
