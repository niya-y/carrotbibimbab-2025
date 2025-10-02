from __future__ import annotations
import io, os
from typing import Optional, List
from fastapi import FastAPI, UploadFile, File, Query, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import cv2
import numpy as np

from .config import DATA_DIR, OUTPUT_DIR
from .pipeline import read_image_bgr, preprocess_image_bgr, detect_landmarks, bytes_to_bgr
from . import supabase_io

app = FastAPI(title="FastAPI Face Pipeline", version="1.0.0")

class ProcessResult(BaseModel):
    num_faces: int
    faces: list
    outputs: List[str]

@app.get("/health")
def health():
    return {"ok": True}

@app.post("/process/local", response_model=ProcessResult)
def process_local(
    filename: str = Query(..., description="Image file inside data/ folder"),
    draw: bool = Query(True, description="Draw mesh overlay and save"),
    max_points: int = Query(0, ge=0, le=468, description="Trim landmarks per face (0=full)")
):
    path = os.path.join(DATA_DIR, filename)
    if not os.path.exists(path):
        raise HTTPException(status_code=404, detail=f"Not found: {path}")
    img = read_image_bgr(path)
    pre = preprocess_image_bgr(img)
    result = detect_landmarks(pre, draw=draw)

    outputs = []
    # Save preprocessed
    pre_path = os.path.join(OUTPUT_DIR, "preprocessed_" + os.path.basename(filename))
    cv2.imwrite(pre_path, pre)
    outputs.append(pre_path)

    # Save overlay
    if draw and result.get("overlay_bgr") is not None:
        overlay = result["overlay_bgr"]
        ov_path = os.path.join(OUTPUT_DIR, "overlay_" + os.path.basename(filename))
        cv2.imwrite(ov_path, overlay)
        outputs.append(ov_path)

    faces = result["faces"]
    if max_points > 0:
        for f in faces:
            f["landmarks"] = f["landmarks"][:max_points]

    return ProcessResult(
        num_faces=result["num_faces"],
        faces=faces,
        outputs=outputs
    )

@app.post("/process/upload", response_model=ProcessResult)
async def process_upload(
    file: UploadFile = File(...),
    draw: bool = Query(True),
    max_points: int = Query(0, ge=0, le=468)
):
    data = await file.read()
    img = bytes_to_bgr(data)

    pre = preprocess_image_bgr(img)
    result = detect_landmarks(pre, draw=draw)

    # Save with same filename
    name = os.path.basename(file.filename or "upload.jpg")
    pre_path = os.path.join(OUTPUT_DIR, "preprocessed_" + name)
    cv2.imwrite(pre_path, pre)
    outputs = [pre_path]

    if draw and result.get("overlay_bgr") is not None:
        overlay = result["overlay_bgr"]
        ov_path = os.path.join(OUTPUT_DIR, "overlay_" + name)
        cv2.imwrite(ov_path, overlay)
        outputs.append(ov_path)

    faces = result["faces"]
    if max_points > 0:
        for f in faces:
            f["landmarks"] = f["landmarks"][:max_points]

    return ProcessResult(
        num_faces=result["num_faces"],
        faces=faces,
        outputs=outputs
    )

@app.post("/process/supabase", response_model=ProcessResult)
def process_supabase(
    path: str = Query(..., description="Path inside Supabase bucket"),
    draw: bool = Query(True),
    max_points: int = Query(0, ge=0, le=468)
):
    try:
        blob = supabase_io.download_bytes(path)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Supabase download failed: {e}")

    img = bytes_to_bgr(blob)
    pre = preprocess_image_bgr(img)
    result = detect_landmarks(pre, draw=draw)

    # Use path tail as name
    name = os.path.basename(path) or "supabase.jpg"
    pre_path = os.path.join(OUTPUT_DIR, "preprocessed_" + name)
    cv2.imwrite(pre_path, pre)
    outputs = [pre_path]

    if draw and result.get("overlay_bgr") is not None:
        overlay = result["overlay_bgr"]
        ov_path = os.path.join(OUTPUT_DIR, "overlay_" + name)
        cv2.imwrite(ov_path, overlay)
        outputs.append(ov_path)

    faces = result["faces"]
    if max_points > 0:
        for f in faces:
            f["landmarks"] = f["landmarks"][:max_points]

    return ProcessResult(
        num_faces=result["num_faces"],
        faces=faces,
        outputs=outputs
    )
