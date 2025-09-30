// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:initial_bf/routes/app_router.dart';
import 'package:camera/camera.dart'; // ⭐ 카메라 임포트 추가
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ⭐ Riverpod 임포트 추가

// ⭐ 전역 카메라 목록 (앱 시작 시점에 미리 초기화)
// 이 리스트는 `photo_capture_screen.dart`에서도 사용됩니다.
List<CameraDescription> cameras = [];

Future<void> main() async {
  // Flutter 앱이 시작되기 전에 네이티브 바인딩을 초기화합니다.
  WidgetsFlutterBinding.ensureInitialized();
  // .env 파일에서 환경 변수를 로드합니다.
  await dotenv.load(fileName: '.env');

  // ⭐ 카메라 초기화 로직 추가
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    // 카메라 초기화 중 오류 발생 시
    print('Error initializing cameras: $e');
    // 사용자에게 오류를 알리거나, 카메라를 사용할 수 없는 상태로 앱을 실행하는 등의 처리를 할 수 있습니다.
    // 예를 들어, SnackBar를 표시하거나 특정 화면으로 리다이렉트할 수 있습니다.
  }

  // Supabase 클라이언트를 초기화합니다.
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // ⭐ Riverpod ProviderScope로 앱을 감싸서 Provider 사용 가능하게 함
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Supabase 클라이언트 인스턴스 (앱 전역에서 쉽게 사용 가능)
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BF',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: router, // go_router 설정
    );
  }
}
