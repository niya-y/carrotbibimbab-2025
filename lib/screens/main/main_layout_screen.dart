// lib/screens/main/main_layout_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({required this.child, super.key});
  final Widget child; // 현재 선택된 탭의 화면 위젯

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0; // 현재 선택된 탭의 인덱스

  // BottomNavigationBar 아이템 정의
  final List<BottomNavigationBarItem> _navBarItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
    BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: '분석'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
  ];

  // 탭을 변경할 때 호출될 함수
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // go_router를 사용하여 해당 탭의 경로로 이동합니다.
    // 현재는 직접적인 경로 매핑이 필요합니다.
    switch (index) {
      case 0:
        context.go('/home'); // 메인 대시보드
        break;
      case 1:
        context.go('/analysis'); // 분석 시작 화면
        break;
      case 2:
        context.go('/mypage'); // 마이 페이지
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 경로에 따라 _currentIndex를 동기화합니다.
    final String location = GoRouterState.of(context).matchedLocation;
    if (location == '/home' && _currentIndex != 0) {
      _currentIndex = 0;
    } else if (location == '/analysis' && _currentIndex != 1) {
      _currentIndex = 1;
    } else if (location == '/mypage' && _currentIndex != 2) {
      _currentIndex = 2;
    }

    return Scaffold(
      body: widget.child, // 현재 선택된 탭의 실제 화면이 여기에 표시됩니다.
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
