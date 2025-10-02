import os
from openai import OpenAI

api_key = os.environ.get("OPENAI_API_KEY")
if not api_key: raise SystemExit("환경변수 OPENAI_API_KEY가 없습니다.")

client = OpenAI(api_key=api_key)
prompt = "안녕! 한 줄로 인사해줘."

resp = client.chat.completions.create(
    model="gpt-4o-mini",
    messages=[{"role": "user", "content": prompt}],
    max_tokens=60,
)
print("응답:", resp.choices[0].message.content.strip())
