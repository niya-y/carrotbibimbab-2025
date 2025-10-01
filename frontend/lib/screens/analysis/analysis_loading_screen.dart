// lib/screens/analysis/analysis_loading_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_bf/services/analysis_service.dart';

class AnalysisLoadingScreen extends StatefulWidget {
  final String imageUrl; // ⭐ String (URL)을 받음 (imagePath 아님!)
  
  const AnalysisLoadingScreen({
    super.key,
    required this.imageUrl,
  });

  @override
  State<AnalysisLoadingScreen> createState() => _AnalysisLoadingScreenState();
}

class _AnalysisLoadingScreenState extends State<AnalysisLoadingScreen> {
  final _analysisService = AnalysisService();

  @override
  void initState() {
    super.initState();
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    try {
      print('🤖 AI 분석 시작...');
      
      final result = await _analysisService.runFullAnalysis(widget.imageUrl);
      
      print('✅ 분석 완료');

      if (mounted) {
        context.go('/analysis-result', extra: result);
      }

    } catch (e) {
      print('❌ 분석 실패: $e');
      
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('분석 실패'),
            content: Text('분석 중 오류가 발생했습니다.\n\n$e'),
            actions: [
              TextButton(
                onPressed: () {
                  context.go('/');
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            
            const Text(
              '분석 중...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AI가 당신의 피부를 분석하고 있습니다',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}