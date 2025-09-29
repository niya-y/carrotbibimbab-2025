// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // PageView의 현재 페이지를 제어하는 컨트롤러
  final PageController _pageController = PageController();
  // 현재 보고 있는 페이지의 인덱스
  int _currentPage = 0;

  // 온보딩 페이지에 들어갈 데이터 목록
  final List<Map<String, String>> _onboardingData = [
    {
      'headline': 'AI로 찾는 나의 진짜 퍼스널 컬러',
      'subline': '조명, 각도에 흔들리지 않는 정확한 진단을 받아보세요.',
    },
    {
      'headline': '민감성 피부를 위한 성분 안전도 분석',
      'subline': '나의 피부 고민에 맞는 성분과 주의해야 할 성분을 알려드려요.',
    },
    {
      'headline': '7일간 기록하는 긍정적인 피부 변화',
      'subline': '매일의 분석 기록으로 나에게 맞는 제품을 찾아보세요.',
    },
  ];

  @override
  void dispose() {
    // 위젯이 사라질 때 PageController도 해제하여 메모리 누수를 방지합니다.
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // 화면 상단 노치 영역 등을 침범하지 않도록 안전 영역에 배치
        child: Column(
          children: [
            // 페이지 내용을 표시하는 PageView
            Expanded(
              // 남은 공간을 모두 차지하도록 확장
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                // 페이지가 변경될 때 _currentPage 상태를 업데이트
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                // 각 페이지의 내용을 빌드
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(
                    headline: _onboardingData[index]['headline']!,
                    subline: _onboardingData[index]['subline']!,
                  );
                },
              ),
            ),
            // 페이지 인디케이터 (현재 페이지를 시각적으로 보여주는 점들)
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: List.generate(
                _onboardingData.length, // 데이터 개수만큼 점 생성
                (index) => _buildDot(index: index), // 각 점 위젯 빌드
              ),
            ),
            const SizedBox(height: 50), // 인디케이터와 버튼 사이 여백
            // 하단 버튼 ([다음] 또는 [뷰파 시작하기])
            Padding(
              padding: const EdgeInsets.all(20.0), // 좌우 패딩
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ), // 버튼의 최소 크기 (가로 가득 채움)
                ),
                onPressed: () {
                  // 현재 페이지가 마지막 페이지인지 확인
                  if (_currentPage == _onboardingData.length - 1) {
                    // ⭐ 마지막 페이지일 경우, 권한 요청 화면으로 이동
                    context.go('/permission'); // go_router를 사용하여 이동
                  } else {
                    // 다음 페이지로 스크롤
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300), // 0.3초 애니메이션
                      curve: Curves.easeIn, // 부드러운 애니메이션 효과
                    );
                  }
                },
                child: Text(
                  // 마지막 페이지에 따라 버튼 텍스트 변경
                  _currentPage == _onboardingData.length - 1 ? '뷰파 시작하기' : '다음',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 💡 [UI 로직] 온보딩의 각 페이지별 UI를 구성하는 위젯
  Widget _buildOnboardingPage({
    required String headline,
    required String subline,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0), // 좌우 패딩
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 세로축 중앙 정렬
        children: [
          // TODO: 나중에 피그마 디자인에 맞춰 각 페이지에 맞는 일러스트 이미지 추가
          // 지금은 임시 아이콘으로 대체
          Icon(
            // 각 페이지 인덱스에 따라 다른 아이콘 표시 (예시)
            _currentPage == 0
                ? Icons.palette
                : _currentPage == 1
                ? Icons.medical_services
                : Icons.calendar_today,
            size: 150,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 40), // 이미지와 헤드라인 사이 여백
          Text(
            headline,
            textAlign: TextAlign.center, // 텍스트 중앙 정렬
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20), // 헤드라인과 서브라인 사이 여백
          Text(
            subline,
            textAlign: TextAlign.center, // 텍스트 중앙 정렬
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 💡 [UI 로직] 페이지 인디케이터의 개별 '점' 위젯
  Widget _buildDot({required int index}) {
    return AnimatedContainer(
      // 상태 변화에 따라 부드러운 애니메이션
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 5), // 점 사이 간격
      height: 6,
      width: _currentPage == index ? 20 : 6, // 현재 페이지 점은 너비를 길게
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colors.blueAccent
            : Colors.grey, // 현재 페이지 점은 색상 강조
        borderRadius: BorderRadius.circular(3), // 둥근 모서리
      ),
    );
  }
}
