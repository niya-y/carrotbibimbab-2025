
"""
process_image.py

Usage (PowerShell / Git Bash):
  # 1) Install deps (once)
  #    pip install opencv-python mediapipe numpy

  # 2) Run (with an input image path)
  #    python process_image.py --img sample.jpg

This script:
  - Denoises (fastNlMeansDenoisingColored)
  - White balances (gray-world)
  - Contrast & color boost (LAB + CLAHE)
  - Gamma correction
  - Extracts skin-tone RGB (median) using MediaPipe Face Mesh (cheek regions)
  - Saves all steps and a 2x3 collage for comparison
"""

import argparse
from dataclasses import dataclass
from typing import Tuple, List
import numpy as np
import cv2
import mediapipe as mp

@dataclass
class SkinTone:
    left_cheek_rgb: Tuple[int, int, int]
    right_cheek_rgb: Tuple[int, int, int]
    avg_rgb: Tuple[int, int, int]

def denoise(img_bgr: np.ndarray) -> np.ndarray:
    # Gentle denoise preserving edges
    return cv2.fastNlMeansDenoisingColored(img_bgr, None, 5, 5, 7, 21)

def white_balance_grayworld(img_bgr: np.ndarray) -> np.ndarray:
    # Gray-world: scale channels so their means equal the global gray mean
    img = img_bgr.astype(np.float32)
    b, g, r = cv2.split(img)
    mean_b, mean_g, mean_r = [ch.mean() for ch in (b, g, r)]
    gray_mean = (mean_b + mean_g + mean_r) / 3.0 + 1e-6
    b = b * (gray_mean / (mean_b + 1e-6))
    g = g * (gray_mean / (mean_g + 1e-6))
    r = r * (gray_mean / (mean_r + 1e-6))
    wb = cv2.merge([b, g, r])
    return np.clip(wb, 0, 255).astype(np.uint8)

def clahe_lab(img_bgr: np.ndarray, clip=2.0, tile=8) -> np.ndarray:
    lab = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2LAB)
    l, a, b = cv2.split(lab)
    clahe = cv2.createCLAHE(clipLimit=clip, tileGridSize=(tile, tile))
    l2 = clahe.apply(l)
    lab2 = cv2.merge([l2, a, b])
    return cv2.cvtColor(lab2, cv2.COLOR_LAB2BGR)

def gamma_correct(img_bgr: np.ndarray, gamma=1.05) -> np.ndarray:
    # Slight brightness lift; gamma < 1: brighter, >1: darker. We'll keep near 1.
    inv_gamma = 1.0 / gamma
    table = np.array([(i / 255.0) ** inv_gamma * 255 for i in range(256)]).astype("uint8")
    return cv2.LUT(img_bgr, table)

def mediapipe_face_landmarks(img_bgr: np.ndarray):
    mp_face = mp.solutions.face_mesh
    with mp_face.FaceMesh(static_image_mode=True, max_num_faces=1, refine_landmarks=True) as face_mesh:
        rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)
        res = face_mesh.process(rgb)
        if not res.multi_face_landmarks:
            return None
        return res.multi_face_landmarks[0]

def pts_from_landmarks(landmarks, shape: Tuple[int, int]) -> List[Tuple[int,int]]:
    h, w = shape[:2]
    return [(int(lm.x * w), int(lm.y * h)) for lm in landmarks.landmark]

def sample_circle(img_bgr: np.ndarray, center_xy: Tuple[int,int], radius: int=12) -> np.ndarray:
    h, w = img_bgr.shape[:2]
    mask = np.zeros((h, w), dtype=np.uint8)
    cx, cy = center_xy
    cv2.circle(mask, (cx, cy), radius, 255, -1)
    pixels = img_bgr[mask==255]
    return pixels

def extract_skin_rgb(img_bgr: np.ndarray, face_landmarks) -> SkinTone:
    pts = pts_from_landmarks(face_landmarks, img_bgr.shape)
    # Mediapipe reference points (approx cheeks); fallback if out-of-bounds
    # Left cheek ~ 234, Right cheek ~ 454 in FaceMesh topology
    li, ri = 234, 454
    li = li if li < len(pts) else 200
    ri = ri if ri < len(pts) else 430
    left_p = pts[li]
    right_p = pts[ri]

    left_pixels = sample_circle(img_bgr, left_p, radius=14)
    right_pixels = sample_circle(img_bgr, right_p, radius=14)

    def median_rgb(pix_bgr: np.ndarray) -> Tuple[int,int,int]:
        if pix_bgr.size == 0:
            return (0,0,0)
        # Convert to RGB for reporting
        pix_rgb = pix_bgr[:, ::-1]  # BGR->RGB
        med = np.median(pix_rgb, axis=0).astype(np.uint8)
        return (int(med[0]), int(med[1]), int(med[2]))

    left_rgb = median_rgb(left_pixels)
    right_rgb = median_rgb(right_pixels)
    avg_rgb = tuple(int(x) for x in np.mean(np.array([left_rgb, right_rgb]), axis=0).round())
    return SkinTone(left_rgb, right_rgb, avg_rgb)

def make_collage(images: List[np.ndarray], labels: List[str], cols=3, pad=10) -> np.ndarray:
    font = cv2.FONT_HERSHEY_SIMPLEX
    font_scale = 0.5
    thickness = 1

    # Resize images to same height
    heights = [im.shape[0] for im in images]
    target_h = min(heights)
    resized = []
    for im in images:
        h, w = im.shape[:2]
        new_w = int(w * (target_h / h))
        resized.append(cv2.resize(im, (new_w, target_h), interpolation=cv2.INTER_AREA))

    # Add labels on top
    labeled = []
    for im, lab in zip(resized, labels):
        canvas = im.copy()
        (tw, th), _ = cv2.getTextSize(lab, font, font_scale, thickness)
        cv2.rectangle(canvas, (0,0), (tw+8, th+8), (255,255,255), -1)
        cv2.putText(canvas, lab, (4, th+4), font, font_scale, (0,0,0), thickness, cv2.LINE_AA)
        labeled.append(canvas)

    # Compose grid
    rows = int(np.ceil(len(labeled) / cols))
    # Compute max width per item after resize
    max_w = max(im.shape[1] for im in labeled)
    # Create rows
    row_imgs = []
    for r in range(rows):
        row = labeled[r*cols:(r+1)*cols]
        # pad to cols
        while len(row) < cols:
            row.append(np.ones_like(labeled[0]) * 255)
        # pad each image to same width
        padded = [cv2.copyMakeBorder(im, pad, pad, pad, pad, cv2.BORDER_CONSTANT, value=(240,240,240)) for im in row]
        # align widths
        padded = [cv2.copyMakeBorder(im, 0, 0, 0, max_w + 2*pad - im.shape[1], cv2.BORDER_CONSTANT, value=(240,240,240)) for im in padded]
        row_imgs.append(np.hstack(padded))
    grid = np.vstack(row_imgs)
    return grid.astype(np.uint8)

def pipeline(img_path: str, out_dir: Path):
    out_dir.mkdir(parents=True, exist_ok=True)
    base = Path(img_path).stem

    img0 = cv2.imread(img_path)
    if img0 is None:
        raise SystemExit(f"Cannot read image: {img_path}")

    step1 = denoise(img0)
    step2 = white_balance_grayworld(step1)
    step3 = clahe_lab(step2, clip=2.0, tile=8)
    step4 = gamma_correct(step3, gamma=0.95)  # slight brightening

    # Save steps
    cv2.imwrite(str(out_dir / f"{base}_0_input.jpg"), img0)
    cv2.imwrite(str(out_dir / f"{base}_1_denoise.jpg"), step1)
    cv2.imwrite(str(out_dir / f"{base}_2_whitebalance.jpg"), step2)
    cv2.imwrite(str(out_dir / f"{base}_3_clahe.jpg"), step3)
    cv2.imwrite(str(out_dir / f"{base}_4_gamma.jpg"), step4)

    # Skin tone reading on the "pretty" image
    face = mediapipe_face_landmarks(step4)
    skin = None
    skin_mask_vis = None

    if face is not None:
        skin = extract_skin_rgb(step4, face)
        # visualize sampling circles
        pts = pts_from_landmarks(face, step4.shape)
        vis = step4.copy()
        for idx in (234, 454):
            if idx < len(pts):
                cv2.circle(vis, pts[idx], 14, (0, 255, 0), 2)
        skin_mask_vis = vis
        cv2.imwrite(str(out_dir / f"{base}_5_skin_sampling.jpg"), vis)

        # Save txt
        txt = (
            f"Left cheek RGB: {skin.left_cheek_rgb}\n"
            f"Right cheek RGB: {skin.right_cheek_rgb}\n"
            f"Average RGB: {skin.avg_rgb}\n"
        )
        (out_dir / f"{base}_skin_rgb.txt").write_text(txt, encoding="utf-8")
    else:
        (out_dir / f"{base}_skin_rgb.txt").write_text("Face landmarks not detected.\n", encoding="utf-8")

    # Collage
    imgs = [img0, step1, step2, step3, step4]
    labels = ["Input", "Denoise", "WhiteBalance", "CLAHE", "Pretty"]
    if skin_mask_vis is not None:
        imgs.append(skin_mask_vis)
        labels.append("SkinSampling")
    collage = make_collage(imgs, labels, cols=3)
    cv2.imwrite(str(out_dir / f"{base}_collage.jpg"), collage)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--img", required=True, help="Path to input image")
    parser.add_argument("--out", default="outputs", help="Output folder")
    args = parser.parse_args()
    pipeline(args.img, Path(args.out))

if __name__ == "__main__":
    main()
