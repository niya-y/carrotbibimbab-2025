# FastAPI Face Pipeline (Mediapipe + OpenCV + Supabase)

## 0) Create & activate venv (Windows PowerShell)
```powershell
cd C:\dev
python -m venv .venv311
. .\.venv311\Scripts\Activate.ps1
```

## 1) Clone or unzip this folder
Place it at `C:\dev\fastapi_face_pipeline` (or anywhere you like).

## 2) Install dependencies
```powershell
cd C:\dev\fastapi_face_pipeline
pip install -r requirements.txt
```

> If you see a build error for `mediapipe` or `opencv-python`, update pip and retry:
```powershell
python -m pip install --upgrade pip wheel setuptools
pip install -r requirements.txt
```

## 3) Configure Supabase (optional)
- Copy `.env.example` to `.env` and fill:
  - `SUPABASE_URL`, `SUPABASE_KEY`, `SUPABASE_BUCKET`

> If your bucket/object is public, an anon key is fine. For private download on server-side, use a service role key (keep it secret!).

## 4) Put your test image
- Put `sample.jpg` into `data/` or use Supabase route.

## 5) Run server
```powershell
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

## 6) Try endpoints

### Health check
```
GET http://127.0.0.1:8000/health
```

### Process local file
```
POST http://127.0.0.1:8000/process/local?filename=sample.jpg&draw=true&max_points=0
```
- Saves outputs to `outputs/` and returns JSON summary.

### Upload and process
```
POST http://127.0.0.1:8000/process/upload?draw=true
Body: form-data, key=file, value=<your image>
```

### Download from Supabase and process
```
POST http://127.0.0.1:8000/process/supabase?path=faces/sample.jpg&draw=true
```
- Requires `.env` set and the object existing in your bucket path.

## 7) Notes
- iOS build is unrelated. This server works on Windows.
- Large landmark arrays are heavy; set `max_points` to 0 (only summary) or a small number to preview.
- For best results with Face Mesh, use clear, frontal faces with good lighting.
