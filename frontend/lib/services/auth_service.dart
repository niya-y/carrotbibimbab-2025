// lib/services/auth_service.dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase 클라이언트 인스턴스
final supabase = Supabase.instance.client;

class AuthService {
  // GoogleSignIn 인스턴스 생성
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google 로그인 및 Supabase 연동
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      // 1. Google 로그인 팝업을 띄워 사용자 계정을 선택하게 합니다.
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google 로그인 취소됨');
        return null; // 사용자가 로그인을 취소한 경우
      }

      // 2. 로그인 성공 시, Google로부터 인증 토큰(idToken, accessToken)을 받아옵니다.
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'Google 로그인 실패: accessToken을 가져올 수 없습니다.';
      }
      if (idToken == null) {
        throw 'Google 로그인 실패: idToken을 가져올 수 없습니다.';
      }

      // 3. 받아온 idToken을 Supabase에 전달하여 Supabase 세션을 생성(로그인)합니다.
      print('Supabase에 Google ID 토큰으로 로그인 시도...');
      return await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      print('Google 로그인 또는 Supabase 연동 실패: $e');
      return null;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Google 계정에서 로그아웃
    await supabase.auth.signOut(); // Supabase 세션에서 로그아웃
    print('로그아웃 완료');
  }

  // 현재 로그인된 사용자 정보 가져오기
  User? get currentUser => supabase.auth.currentUser;
}
