from fastapi import FastAPI, Query
app = FastAPI(title="Face API")
import os, argparse
import numpy as np
import cv2
from dotenv import load_dotenv

# --- Mediapipe ---
import mediapipe as mp
mp_face_mesh = mp.solutions.face_mesh

# --- Supabase ---
from supabase import create_client

def gray_world_white_balance(img_bgr: np.ndarray) -> np.ndarray:
    f = img_bgr.astype(np.float32)
    b, g, r = f[:, :, 0], f[:, :, 1], f[:, :, 2]
    avg = (b.mean() + g.mean() + r.mean()) / 3.0 + 1e-6
    f[:, :, 0] *= (avg / (b.mean() + 1e-6))
    f[:, :, 1] *= (avg / (g.mean() + 1e-6))
    f[:, :, 2] *= (avg / (r.mean() + 1e-6))
    return np.clip(f, 0, 255).astype(np.uint8)

def preprocess(img_bgr: np.ndarray) -> np.ndarray:
    denoised = cv2.bilateralFilter(img_bgr, d=7, sigmaColor=75, sigmaSpace=75)
    balanced = gray_world_white_balance(denoised)
    lab = cv2.cvtColor(balanced, cv2.COLOR_BGR2LAB)
    L, A, B = cv2.split(lab)
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    L2 = clahe.apply(L)
    lab2 = cv2.merge([L2, A, B])
    return cv2.cvtColor(lab2, cv2.COLOR_LAB2BGR)

def detect_landmarks(pre_bgr: np.ndarray, draw: bool = True):
    rgb = cv2.cvtColor(pre_bgr, cv2.COLOR_BGR2RGB)
    overlay = pre_bgr.copy()
    with mp_face_mesh.FaceMesh(
        static_image_mode=True,
        max_num_faces=2,
        refine_landmarks=True,
        min_detection_confidence=0.5
    ) as mesh:
        out = mesh.process(rgb)

    num = 0
    if out.multi_face_landmarks:
        num = len(out.multi_face_landmarks)
        if draw:
            mp_drawing = mp.solutions.drawing_utils
            mp_styles = mp.solutions.drawing_styles
            for lm in out.multi_face_landmarks:
                mp_drawing.draw_landmarks(
                    image=overlay,
                    landmark_list=lm,
                    connections=mp_face_mesh.FACEMESH_TESSELATION,
                    landmark_drawing_spec=None,
                    connection_drawing_spec=mp_styles.get_default_face_mesh_tesselation_style()
                )
                mp_drawing.draw_landmarks(
                    image=overlay,
                    landmark_list=lm,
                    connections=mp_face_mesh.FACEMESH_CONTOURS,
                    landmark_drawing_spec=None,
                    connection_drawing_spec=mp_styles.get_default_face_mesh_contours_style()
                )
                mp_drawing.draw_landmarks(
                    image=overlay,
                    landmark_list=lm,
                    connections=mp_face_mesh.FACEMESH_IRISES,
                    landmark_drawing_spec=None,
                    connection_drawing_spec=mp_styles.get_default_face_mesh_iris_connections_style()
                )
    return num, overlay

def read_local(path: str) -> np.ndarray:
    img = cv2.imread(path)
    if img is None:
        raise FileNotFoundError(f"이미지 없음: {path}")
    return img

def read_from_supabase(obj_path: str):
    load_dotenv()
    url = os.getenv("SUPABASE_URL", "")
    key = os.getenv("SUPABASE_KEY", "")
    bucket = os.getenv("SUPABASE_BUCKET", "images")
    if not url or not key:
        raise RuntimeError("Supabase 설정(.env)이 비어있습니다.")
    client = create_client(url, key)
    data = client.storage.from_(bucket).download(obj_path)
    arr = np.frombuffer(data, dtype=np.uint8)
    img = cv2.imdecode(arr, cv2.IMREAD_COLOR)
    if img is None:
        raise ValueError("Supabase 바이트 디코딩 실패")
    name = os.path.basename(obj_path) or "supabase.jpg"
    return img, name

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", choices=["local","supabase"], default="local")
    parser.add_argument("--input", default="sample.jpg", help="로컬 파일명")
    parser.add_argument("--path", help="Supabase 버킷 내부 경로 (예: faces/sample.jpg)")
    parser.add_argument("--outdir", default="outputs")
    parser.add_argument("--draw", action="store_true", help="랜드마크 오버레이 저장")
    args = parser.parse_args()

    os.makedirs(args.outdir, exist_ok=True)

    if args.source == "local":
        img = read_local(args.input)
        base_name = os.path.basename(args.input)
    else:
        if not args.path:
            raise SystemExit("--source supabase 를 쓰면 --path 를 꼭 넣어주세요")
        img, base_name = read_from_supabase(args.path)

    pre = preprocess(img)
    pre_path = os.path.join(args.outdir, f"preprocessed_{base_name}")
    cv2.imwrite(pre_path, pre)

    num_faces, overlay = detect_landmarks(pre, draw=args.draw)
    if args.draw:
        ov_path = os.path.join(args.outdir, f"overlay_{base_name}")
        cv2.imwrite(ov_path, overlay)
        print(f"[OK] 오버레이 저장: {ov_path}")

    print(f"[OK] 전처리 저장: {pre_path}")
    print(f"[OK] 얼굴 인식: {num_faces}명")

if __name__ == "__main__":
    main()
@app.get("/health")
def health():
    return {"ok": True}

@app.post("/process/local")
def process_local(filename: str = Query(..., description="예: sample.jpg 또는 team/sample.jpg")):
    import os, cv2
    img = read_local(filename)
    pre = preprocess(img)
    name = os.path.basename(filename)
    os.makedirs("outputs", exist_ok=True)
    pre_path = os.path.join("outputs", f"preprocessed_{name}")
    cv2.imwrite(pre_path, pre)
    num, overlay = detect_landmarks(pre, draw=True)
    ov_path = os.path.join("outputs", f"overlay_{name}")
    cv2.imwrite(ov_path, overlay)
    return {"num_faces": num, "outputs": [pre_path, ov_path]}

@app.post("/process/supabase")
def process_supabase(path: str = Query(..., description="버킷 내부 경로, 예: faces/sample.jpg")):
    import os, cv2
    img, name = read_from_supabase(path)      # .env에서 URL/KEY/Bucket 읽음
    pre = preprocess(img)
    os.makedirs("outputs", exist_ok=True)
    pre_path = os.path.join("outputs", f"preprocessed_{name}")
    cv2.imwrite(pre_path, pre)
    num, overlay = detect_landmarks(pre, draw=True)
    ov_path = os.path.join("outputs", f"overlay_{name}")
    cv2.imwrite(ov_path, overlay)
    return {"num_faces": num, "outputs": [pre_path, ov_path]}

