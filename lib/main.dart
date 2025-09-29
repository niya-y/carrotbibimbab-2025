// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:initial_bf/routes/app_router.dart';

Future<void> main() async {
  // Flutter 앱이 시작되기 전에 네이티브 바인딩을 초기화합니다.
  WidgetsFlutterBinding.ensureInitialized();
  // .env 파일에서 환경 변수를 로드합니다.
  await dotenv.load(fileName: '.env');

  // Supabase 클라이언트를 초기화합니다.
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
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
