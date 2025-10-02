from __future__ import annotations
import os
import cv2
import numpy as np
from typing import Dict, Any, List, Tuple

# Mediapipe imports
import mediapipe as mp
mp_face_mesh = mp.solutions.face_mesh
mp_drawing = mp.solutions.drawing_utils
mp_styles = mp.solutions.drawing_styles

# Lazy singletons
_FACE_MESH = None

def get_face_mesh(max_faces: int = 1):
    global _FACE_MESH
    if _FACE_MESH is None:
        _FACE_MESH = mp_face_mesh.FaceMesh(
            static_image_mode=True,
            max_num_faces=max_faces,
            refine_landmarks=True,   # iris, lips detail
            min_detection_confidence=0.5,
            min_tracking_confidence=0.5,
        )
    return _FACE_MESH

def read_image_bgr(path: str) -> np.ndarray:
    img = cv2.imread(path)
    if img is None:
        raise FileNotFoundError(f"Image not found: {path}")
    return img

def bytes_to_bgr(data: bytes) -> np.ndarray:
    arr = np.frombuffer(data, dtype=np.uint8)
    img = cv2.imdecode(arr, cv2.IMREAD_COLOR)
    if img is None:
        raise ValueError("Failed to decode image bytes")
    return img

def preprocess_image_bgr(img_bgr: np.ndarray) -> np.ndarray:
    # 1) Denoise (gentle)
    denoised = cv2.bilateralFilter(img_bgr, d=7, sigmaColor=75, sigmaSpace=75)

    # 2) Color balance (gray world)
    balanced = gray_world_white_balance(denoised)

    # 3) Contrast enhancement via CLAHE on L channel
    lab = cv2.cvtColor(balanced, cv2.COLOR_BGR2LAB)
    L, A, B = cv2.split(lab)
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
    L2 = clahe.apply(L)
    lab2 = cv2.merge([L2, A, B])
    out = cv2.cvtColor(lab2, cv2.COLOR_LAB2BGR)

    return out

def gray_world_white_balance(img_bgr: np.ndarray) -> np.ndarray:
    result = img_bgr.astype(np.float32)
    avg_b = np.mean(result[:,:,0])
    avg_g = np.mean(result[:,:,1])
    avg_r = np.mean(result[:,:,2])
    avg_gray = (avg_b + avg_g + avg_r) / 3.0 + 1e-6
    result[:,:,0] *= (avg_gray / avg_b)
    result[:,:,1] *= (avg_gray / avg_g)
    result[:,:,2] *= (avg_gray / avg_r)
    result = np.clip(result, 0, 255).astype(np.uint8)
    return result

def detect_landmarks(img_bgr: np.ndarray, draw: bool = True) -> Dict[str, Any]:
    h, w = img_bgr.shape[:2]
    rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)

    face_mesh = get_face_mesh(max_faces=2)
    out = face_mesh.process(rgb)

    faces = []
    overlay = img_bgr.copy()

    if out.multi_face_landmarks:
        for face_idx, lm in enumerate(out.multi_face_landmarks, start=1):
            # Collect points
            pts = [(int(p.x * w), int(p.y * h)) for p in lm.landmark]
            bbox = bbox_from_points(pts)
            faces.append({
                "index": face_idx,
                "landmarks": pts,   # 468 points
                "bbox": bbox
            })
            if draw:
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

    return {
        "num_faces": len(faces),
        "faces": faces,
        "overlay_bgr": overlay if draw else None
    }

def bbox_from_points(points: List[Tuple[int,int]]) -> Dict[str,int]:
    xs = [x for x,_ in points]
    ys = [y for _,y in points]
    x0, x1 = int(np.min(xs)), int(np.max(xs))
    y0, y1 = int(np.min(ys)), int(np.max(ys))
    return {"x": x0, "y": y0, "w": x1 - x0, "h": y1 - y0}
