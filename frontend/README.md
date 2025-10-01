# VUPA - AI 뷰티 가이드 앱

## 🚀 시작하기 (Mac 팀원용)

### 1. 프로젝트 클론

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name/frontend
```

### 2. Flutter 패키지 설치

```bash
flutter pub get
```

### 3. 환경 변수 설정

프로젝트 루트에 `.env` 파일 생성:

```bash
# frontend/.env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

**Supabase 키 받기:**
- Supabase Dashboard → Project Settings → API
- URL과 anon public 키 복사

### 4. iOS 설정

```bash
cd ios
pod install
cd ..
```

### 5. 앱 실행

```bash
# iOS 시뮬레이터
flutter run

# 실제 기기
flutter run -d <device-id>
```

---

## 📁 프로젝트 구조

```
frontend/
├── lib/
│   ├── main.dart
│   ├── services/
│   │   ├── supabase_service.dart
│   │   ├── image_upload_service.dart
│   │   └── analysis_service.dart
│   ├── screens/
│   │   ├── analysis/
│   │   └── result/
│   └── routes/
│       └── app_router.dart
├── pubspec.yaml
└── .env (직접 생성 필요!)
```

---

## 🔧 주요 기능

- 📷 얼굴 사진 촬영
- ☁️ Supabase Storage 업로드
- 🤖 AI 얼굴 분석 (Edge Functions)
- 📊 맞춤형 뷰티 가이드 생성

---

## 🐛 문제 해결

### "No pubspec.yaml found" 오류
```bash
# frontend 폴더에 있는지 확인
pwd
cd frontend
```

### 패키지 오류
```bash
flutter clean
flutter pub get
```

### iOS Pod 오류
```bash
cd ios
pod deintegrate
pod install
cd ..
```

---