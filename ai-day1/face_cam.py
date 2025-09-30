# 아주 쉬운 얼굴 인식 예제 (웹캠 필요)
import cv2, mediapipe as mp, time

cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)  # 0번 웹캠
face = mp.solutions.face_detection.FaceDetection(
    model_selection=0, min_detection_confidence=0.5
)
draw = mp.solutions.drawing_utils

prev = 0.0
while True:
    ok, frame = cap.read()
    if not ok:
        break

    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)  # BGR -> RGB
    res = face.process(rgb)                       # 얼굴 찾기

    if res.detections:
        for d in res.detections:
            draw.draw_detection(frame, d)         # 네모/점 그리기

    now = time.time()
    fps = 1/(now - prev) if prev else 0
    prev = now
    cv2.putText(frame, f"FPS: {fps:.1f}", (10,30),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (255,255,255), 2)

    cv2.imshow("얼굴 인식 (q로 종료)", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
import cv2, mediapipe as mp, time

cap = cv2.VideoCapture(0, cv2.CAP_DSHOW)  # 0: 기본 웹캠
if not cap.isOpened():
    raise SystemExit("웹캠을 열 수 없어요. 다른 앱 종료/권한/장치번호 확인")

fd = mp.solutions.face_detection.FaceDetection(model_selection=0, min_detection_confidence=0.5)
draw = mp.solutions.drawing_utils

prev = 0.0
print("카메라 창에서 q를 누르면 종료")
while True:
    ok, frame = cap.read()
    if not ok: break
    h, w = frame.shape[:2]

    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    res = fd.process(rgb)

    if res.detections:
        for d in res.detections:
            draw.draw_detection(frame, d)  # 네모+키포인트
            box = d.location_data.relative_bounding_box
            x1,y1 = int(box.xmin*w), int(box.ymin*h)
            x2,y2 = int((box.xmin+box.width)*w), int((box.ymin+box.height)*h)
            cv2.putText(frame, f"{x1},{y1}-{x2},{y2}", (x1, max(0,y1-8)),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,255,0), 1)

    now = time.time()
    fps = 1/(now-prev) if prev else 0; prev = now
    cv2.putText(frame, f"FPS:{fps:.1f}", (10,30), cv2.FONT_HERSHEY_SIMPLEX, 1, (255,255,255), 2)

    cv2.imshow("Face (q to quit)", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'): break

cap.release(); cv2.destroyAllWindows()

