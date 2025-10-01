// lib/screens/analysis/photo_confirm_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:initial_bf/services/image_upload_service.dart';

class PhotoConfirmScreen extends StatefulWidget {
  final File imageFile; // ⭐ File 타입으로 받음 (imagePath 아님!)
  
  const PhotoConfirmScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<PhotoConfirmScreen> createState() => _PhotoConfirmScreenState();
}

class _PhotoConfirmScreenState extends State<PhotoConfirmScreen> {
  final _imageUploadService = ImageUploadService();
  bool _isUploading = false;

  Future<void> _startAnalysis() async {
    setState(() {
      _isUploading = true;
    });

    try {
      print('📤 이미지 업로드 시작...');
      final imageUrl = await _imageUploadService.uploadImage(widget.imageFile);
      print('✅ 업로드 완료: $imageUrl');

      if (mounted) {
        context.go('/analysis-loading', extra: imageUrl);
      }

    } catch (e) {
      print('❌ 업로드 실패: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지 업로드 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 확인'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.contain,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isUploading ? null : () {
                      context.pop();
                    },
                    child: const Text('다시 찍기'),
                  ),
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _startAnalysis,
                    child: _isUploading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('분석하기'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}