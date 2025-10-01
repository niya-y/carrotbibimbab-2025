// lib/services/image_upload_service.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'supabase_service.dart';

/// 이미지 업로드 서비스
class ImageUploadService {
  final _supabase = SupabaseService();
  
  // 싱글톤 패턴
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  ImageUploadService._internal();

  /// Storage 버킷 이름
  static const String bucketName = 'face-images';

  /// 이미지 파일을 Supabase Storage에 업로드
  /// 
  /// [imageFile] - 업로드할 이미지 파일
  /// [userId] - 사용자 ID (선택, 없으면 현재 로그인된 사용자)
  /// 
  /// Returns: 업로드된 이미지의 공개 URL
  Future<String> uploadImage(File imageFile, {String? userId}) async {
    final currentUserId = userId ?? _supabase.currentUserId;
    
    if (currentUserId == null) {
      throw Exception('로그인이 필요합니다.');
    }

    print('이미지 업로드 시작...');
    print('파일 경로: ${imageFile.path}');

    try {
      // 파일 확장자 가져오기
      final fileExtension = path.extension(imageFile.path);
      
      // 고유한 파일명 생성: userId_timestamp.확장자
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${currentUserId}_$timestamp$fileExtension';
      
      // Storage 경로: face-images/userId/fileName
      final storagePath = '$currentUserId/$fileName';

      print('Storage 경로: $storagePath');

      // 파일 업로드
      final uploadPath = await _supabase.client.storage
          .from(bucketName)
          .upload(
            storagePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false, // 같은 이름 파일이 있으면 오류 발생
            ),
          );

      print('업로드 성공: $uploadPath');

      // 공개 URL 가져오기
      final publicUrl = _supabase.client.storage
          .from(bucketName)
          .getPublicUrl(storagePath);

      print('🔗 Public URL: $publicUrl');

      return publicUrl;

    } on StorageException catch (e) {
      print('Storage 오류: ${e.message}');
      throw Exception('이미지 업로드 실패: ${e.message}');
    } catch (e) {
      print('업로드 실패: $e');
      throw Exception('이미지 업로드 중 오류가 발생했습니다.');
    }
  }

  /// 이미지 삭제
  /// 
  /// [imagePath] - Storage 경로 (예: 'userId/fileName.jpg')
  Future<void> deleteImage(String imagePath) async {
    print('이미지 삭제 시도: $imagePath');
    
    try {
      await _supabase.client.storage
          .from(bucketName)
          .remove([imagePath]);
      
      print('이미지 삭제 성공');
    } on StorageException catch (e) {
      print('Storage 오류: ${e.message}');
      throw Exception('이미지 삭제 실패: ${e.message}');
    } catch (e) {
      print('삭제 실패: $e');
      rethrow;
    }
  }

  /// 사용자의 모든 이미지 목록 가져오기
  /// 
  /// [userId] - 사용자 ID (선택, 없으면 현재 로그인된 사용자)
  Future<List<FileObject>> getUserImages({String? userId}) async {
    final currentUserId = userId ?? _supabase.currentUserId;
    
    if (currentUserId == null) {
      throw Exception('로그인이 필요합니다.');
    }

    print('사용자 이미지 목록 조회: $currentUserId');

    try {
      final files = await _supabase.client.storage
          .from(bucketName)
          .list(path: currentUserId);

      print('이미지 ${files.length}개 발견');
      return files;

    } on StorageException catch (e) {
      print('Storage 오류: ${e.message}');
      throw Exception('이미지 목록 조회 실패: ${e.message}');
    } catch (e) {
      print('조회 실패: $e');
      rethrow;
    }
  }

  /// URL에서 Storage 경로 추출
  /// 
  /// 예: https://xxx.supabase.co/storage/v1/object/public/face-images/userId/file.jpg
  /// → userId/file.jpg
  String getStoragePathFromUrl(String publicUrl) {
    final uri = Uri.parse(publicUrl);
    final pathSegments = uri.pathSegments;
    
    // 'storage/v1/object/public/face-images' 다음부터가 실제 경로
    final bucketIndex = pathSegments.indexOf(bucketName);
    if (bucketIndex == -1 || bucketIndex >= pathSegments.length - 1) {
      throw Exception('잘못된 URL 형식입니다.');
    }
    
    return pathSegments.sublist(bucketIndex + 1).join('/');
  }
}