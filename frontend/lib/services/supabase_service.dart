// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase 관련 유틸리티 서비스
class SupabaseService {
  // 싱글톤 패턴
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  /// Supabase 클라이언트 가져오기
  SupabaseClient get client => Supabase.instance.client;

  /// 현재 로그인된 사용자 가져오기
  User? get currentUser => client.auth.currentUser;

  /// 현재 사용자 ID 가져오기
  String? get currentUserId => currentUser?.id;

  /// 로그인 여부 확인
  bool get isLoggedIn => currentUser != null;

  /// 인증 상태 변화 스트림
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  /// 익명 로그인 (테스트용)
  /// 실제 프로덕션에서는 소셜 로그인을 사용하세요
  Future<AuthResponse> signInAnonymously() async {
    print('익명 로그인 시도...');
    try {
      final response = await client.auth.signInAnonymously();
      print('익명 로그인 성공: ${response.user?.id}');
      return response;
    } catch (e) {
      print('익명 로그인 실패  : $e');
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    print('로그아웃 시도...');
    try {
      await client.auth.signOut();
      print('로그아웃 성공');
    } catch (e) {
      print('로그아웃 실패: $e');
      rethrow;
    }
  }

  /// 사용자 프로필 가져오기 (profiles 테이블)
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    print('사용자 프로필 조회: $userId');
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      print('프로필 조회 성공');
      return response;
    } catch (e) {
      print('프로필 조회 실패: $e');
      return null;
    }
  }

  /// 사용자 프로필 업데이트
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    print('프로필 업데이트: $userId');
    try {
      await client
          .from('profiles')
          .update(data)
          .eq('id', userId);
      print('프로필 업데이트 성공');
    } catch (e) {
      print('프로필 업데이트 실패: $e');
      rethrow;
    }
  }
}