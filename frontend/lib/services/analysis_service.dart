// lib/services/analysis_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

/// AI 분석 서비스 (Edge Functions 호출)
class AnalysisService {
  final _supabase = SupabaseService();
  
  // 싱글톤 패턴
  static final AnalysisService _instance = AnalysisService._internal();
  factory AnalysisService() => _instance;
  AnalysisService._internal();

  /// Edge Function: 얼굴 이미지 분석
  /// 
  /// [imageUrl] - 분석할 이미지의 공개 URL
  /// [userId] - 사용자 ID (선택)
  /// 
  /// Returns: 분석 결과 JSON
  Future<Map<String, dynamic>> analyzeImage(
    String imageUrl, {
    String? userId,
  }) async {
    final currentUserId = userId ?? _supabase.currentUserId;
    
    print('얼굴 분석 시작...');
    print('이미지 URL: $imageUrl');
    print('사용자 ID: $currentUserId');

    try {
      final response = await _supabase.client.functions.invoke(
        'analyze-face',
        body: {
          'imageUrl': imageUrl,
          'userId': currentUserId,
        },
      );

      print('분석 완료');
      print('결과: ${response.data}');

      if (response.data == null) {
        throw Exception('분석 결과가 비어있습니다.');
      }

      return response.data as Map<String, dynamic>;

    } on FunctionException catch (e) {
      print('Edge Function 오류');
      print('상태 코드: ${e.status}');
      print('상세: ${e.details}');
      throw Exception('얼굴 분석 실패: ${e.details}');
    } catch (e) {
      print('분석 실패: $e');
      throw Exception('얼굴 분석 중 오류가 발생했습니다: $e');
    }
  }

  /// Edge Function: 뷰티 가이드 생성
  /// 
  /// [analysisResult] - analyzeImage()의 결과
  /// [userPreferences] - 사용자 선호도 (선택)
  /// 
  /// Returns: 맞춤형 뷰티 가이드
  Future<Map<String, dynamic>> generateBeautyGuide(
    Map<String, dynamic> analysisResult, {
    Map<String, dynamic>? userPreferences,
  }) async {
    print('뷰티 가이드 생성 시작...');

    try {
      final response = await _supabase.client.functions.invoke(
        'generate-beauty-guide',
        body: {
          'analysisResult': analysisResult,
          'userPreferences': userPreferences ?? {},
        },
      );

      print('가이드 생성 완료');
      print('결과: ${response.data}');

      if (response.data == null) {
        throw Exception('가이드 생성 결과가 비어있습니다.');
      }

      return response.data as Map<String, dynamic>;

    } on FunctionException catch (e) {
      print('Edge Function 오류');
      print('상태 코드: ${e.status}');
      print('상세: ${e.details}');
      throw Exception('가이드 생성 실패: ${e.details}');
    } catch (e) {
      print('가이드 생성 실패: $e');
      throw Exception('가이드 생성 중 오류가 발생했습니다: $e');
    }
  }

  /// 전체 플로우: 이미지 업로드 → 분석 → 가이드 생성
  /// 
  /// [imageUrl] - 이미지 URL
  /// [userPreferences] - 사용자 선호도 (선택)
  /// 
  /// Returns: {
  ///   'analysis': 분석 결과,
  ///   'guide': 뷰티 가이드,
  ///   'analysisId': 분석 ID (DB 저장된 경우)
  /// }
  Future<Map<String, dynamic>> runFullAnalysis(
    String imageUrl, {
    Map<String, dynamic>? userPreferences,
  }) async {
    print('전체 분석 플로우 시작');

    try {
      // 1단계: 얼굴 분석
      print('1단계: 얼굴 분석');
      final analysisResult = await analyzeImage(imageUrl);

      // 2단계: 뷰티 가이드 생성
      print('2단계: 뷰티 가이드 생성');
      final beautyGuide = await generateBeautyGuide(
        analysisResult,
        userPreferences: userPreferences,
      );

      print('전체 분석 완료');

      return {
        'analysis': analysisResult,
        'guide': beautyGuide,
        'timestamp': DateTime.now().toIso8601String(),
      };

    } catch (e) {
      print('전체 분석 실패: $e');
      rethrow;
    }
  }

  /// 분석 기록을 데이터베이스에 저장
  /// 
  /// [imageUrl] - 이미지 URL
  /// [analysisResult] - 분석 결과
  /// [userId] - 사용자 ID (선택)
  Future<String> saveAnalysisRecord(
    String imageUrl,
    Map<String, dynamic> analysisResult, {
    String? userId,
  }) async {
    final currentUserId = userId ?? _supabase.currentUserId;

    print('분석 기록 저장...');

    try {
      final response = await _supabase.client
          .from('analysis_records')
          .insert({
            'user_id': currentUserId,
            'image_url': imageUrl,
            'analysis_data': analysisResult,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final analysisId = response['id'] as String;
      print('분석 기록 저장 완료: $analysisId');

      return analysisId;

    } catch (e) {
      print('저장 실패: $e');
      throw Exception('분석 기록 저장 실패: $e');
    }
  }

  /// 사용자의 분석 기록 조회
  /// 
  /// [userId] - 사용자 ID (선택)
  /// [limit] - 가져올 최대 개수
  Future<List<Map<String, dynamic>>> getAnalysisHistory({
    String? userId,
    int limit = 10,
  }) async {
    final currentUserId = userId ?? _supabase.currentUserId;

    print('분석 기록 조회: $currentUserId');

    try {
      // ⭐ Nullable 체크 추가
      if (currentUserId == null) {
        throw Exception('로그인이 필요합니다.');
      }

      final response = await _supabase.client
          .from('analysis_records')
          .select()
          .eq('user_id', currentUserId) // 이제 null이 아님이 보장됨
          .order('created_at', ascending: false)
          .limit(limit);

      print('기록 ${response.length}개 조회됨');
      return List<Map<String, dynamic>>.from(response);

    } catch (e) {
      print('조회 실패: $e');
      throw Exception('분석 기록 조회 실패: $e');
    }
  }
}