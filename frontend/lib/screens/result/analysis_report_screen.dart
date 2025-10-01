// lib/screens/result/analysis_report_screen.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/models/analysis_result.dart'; // 기존 모델

class AnalysisReportScreen extends StatelessWidget {
  // ⭐ 두 가지 방식 모두 지원
  final AnalysisResult? result; // 기존 방식
  final Map<String, dynamic>? resultMap; // 새로운 방식
  
  const AnalysisReportScreen({
    super.key,
    this.result,
    this.resultMap,
  }) : assert(result != null || resultMap != null, 'result 또는 resultMap 중 하나는 필수입니다');

  @override
  Widget build(BuildContext context) {
    // ⭐ 기존 AnalysisResult 사용
    if (result != null) {
      return _buildWithAnalysisResult(context);
    }
    
    // ⭐ 새로운 Map 사용 (Edge Function 결과)
    if (resultMap != null) {
      return _buildWithMap(context);
    }
    
    return const Scaffold(
      body: Center(child: Text('결과를 불러올 수 없습니다')),
    );
  }
  
  // 기존 AnalysisResult로 화면 구성
  Widget _buildWithAnalysisResult(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('분석 결과')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '기존 분석 결과',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // 기존 result 객체를 사용한 UI
            // ... 기존 코드 유지 ...
          ],
        ),
      ),
    );
  }
  
  // 새로운 Map으로 화면 구성
  Widget _buildWithMap(BuildContext context) {
    final analysis = resultMap!['analysis'] as Map<String, dynamic>?;
    final guide = resultMap!['guide'] as Map<String, dynamic>?;
    
    if (analysis == null || guide == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('분석 결과')),
        body: const Center(child: Text('분석 결과 형식이 올바르지 않습니다')),
      );
    }
    
    final skinType = analysis['skinType'] as String? ?? 'unknown';
    final concerns = (analysis['concerns'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 결과'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 피부 타입
            Text(
              '피부 타입',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.teal.shade700),
                  const SizedBox(width: 12),
                  Text(
                    _getSkinTypeName(skinType),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // 피부 고민
            if (concerns.isNotEmpty) ...[
              Text(
                '피부 고민',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...concerns.map((concern) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.warning_amber,
                      color: _getSeverityColor(concern['severity'] as String?),
                    ),
                    title: Text(_getConcernName(concern['type'] as String?)),
                    subtitle: Text('심각도: ${_getSeverityText(concern['severity'] as String?)}'),
                  ),
                );
              }).toList(),
              const SizedBox(height: 24),
            ],
            
            // 추천 루틴
            Text(
              '추천 스킨케어 루틴',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // 아침 루틴
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.wb_sunny, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Text(
                        '아침 루틴',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._buildRoutine(
                    (guide['personalizedRoutine']?['morning'] as List?)?.cast<Map<String, dynamic>>() ?? [],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // 저녁 루틴
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.nightlight, color: Colors.indigo.shade700),
                      const SizedBox(width: 8),
                      Text(
                        '저녁 루틴',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._buildRoutine(
                    (guide['personalizedRoutine']?['evening'] as List?)?.cast<Map<String, dynamic>>() ?? [],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // 라이프스타일 팁
            if (guide['lifestyleTips'] != null) ...[
              Text(
                '생활 습관 팁',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...(guide['lifestyleTips'] as List).map((tip) {
                return ListTile(
                  leading: const Icon(Icons.lightbulb_outline, color: Colors.amber),
                  title: Text(tip.toString()),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  // 루틴 단계 리스트 생성
  List<Widget> _buildRoutine(List<Map<String, dynamic>> routine) {
    return routine.map<Widget>((step) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.teal.shade700,
              child: Text(
                '${step['step']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['name'] as String? ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step['description'] as String? ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // 피부 타입 한글 이름
  String _getSkinTypeName(String? type) {
    const names = {
      'dry': '건성',
      'oily': '지성',
      'combination': '복합성',
      'sensitive': '민감성',
    };
    return names[type] ?? (type ?? '알 수 없음');
  }

  // 고민 한글 이름
  String _getConcernName(String? type) {
    const names = {
      'acne': '여드름',
      'redness': '홍조',
      'dryness': '건조',
      'hyperpigmentation': '색소침착',
    };
    return names[type] ?? (type ?? '알 수 없음');
  }
  
  // 심각도 텍스트
  String _getSeverityText(String? severity) {
    const texts = {
      'mild': '경미',
      'moderate': '보통',
      'severe': '심함',
    };
    return texts[severity] ?? (severity ?? '알 수 없음');
  }
  
  // 심각도 색상
  Color _getSeverityColor(String? severity) {
    switch (severity) {
      case 'mild':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}