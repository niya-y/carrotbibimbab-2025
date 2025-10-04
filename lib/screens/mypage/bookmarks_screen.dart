// lib/screens/mypage/bookmarks_screen.dart
import 'package:flutter/material.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/models/product.dart'; // Product 모델
import 'package:initial_bf/widgets/cards/product_card.dart'; // 재사용 ProductCard 위젯
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  bool _isLoading = true;
  List<Product> _bookmarkedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedProducts();
  }

  // 💡 [핵심 로직] Supabase에서 북마크된 제품만 가져오기 (시뮬레이션)
  Future<void> _fetchBookmarkedProducts() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1)); // 1초 로딩 시뮬레이션

    // TODO: 실제 Supabase 연동 코드
    /*
    try {
      // is_bookmarked 컬럼이 true인 제품만 가져옵니다.
      final response = await supabase
          .from('products')
          .select()
          .eq('is_bookmarked', true)
          .order('name', ascending: true); // 이름순으로 정렬

      final products = (response as List)
          .map((json) => Product.fromJson(json))
          .toList();
      
      setState(() {
        _bookmarkedProducts = products;
        _isLoading = false;
      });

    } catch (e) {
      // ... 에러 처리 ...
    }
    */

    // 더미 데이터 생성 (북마크된 제품만 있다고 가정)
    final dummyProducts = [
      Product(
          id: 2,
          name: '글로우 파운데이션',
          brand: '컬러랩',
          imageUrl: 'https://picsum.photos/id/20/200/200',
          safetyScore: 4.5,
          isBookmarked: true),
      Product(
          id: 5,
          name: '하이드로 에센스',
          brand: '뷰파 코스메틱',
          imageUrl: 'https://picsum.photos/id/50/200/200',
          safetyScore: 4.7,
          isBookmarked: true),
    ];

    setState(() {
      _bookmarkedProducts = dummyProducts;
      _isLoading = false;
    });
  }

  // 💡 [핵심 로직] 북마크 해제
  void _unBookmarkProduct(Product product) {
    setState(() {
      // UI에서 즉시 제거하여 빠른 피드백 제공
      _bookmarkedProducts.removeWhere((p) => p.id == product.id);
    });

    // TODO: 실제 Supabase DB에 북마크 해제 상태 업데이트
    /*
    Future(() async {
      try {
        await supabase
            .from('products')
            .update({'is_bookmarked': false})
            .eq('id', product.id);
      } catch (e) {
        // 에러 발생 시 UI를 원상 복구하거나 사용자에게 알림
        print("Error unbookmarking: $e");
        setState(() { _bookmarkedProducts.add(product); }); // 예시: 다시 리스트에 추가
      }
    });
    */

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} 북마크가 해제되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookmarkedProducts.isEmpty
              ? const Center(
                  child: Text(
                    '북마크한 제품이 없습니다.',
                    style: TextStyle(color: AppColors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _bookmarkedProducts.length,
                  itemBuilder: (context, index) {
                    final product = _bookmarkedProducts[index];
                    return ProductCard(
                      product: product,
                      onBookmarkPressed: () {
                        // 북마크 페이지에서는 북마크 아이콘 클릭 시 북마크 해제
                        _unBookmarkProduct(product);
                      },
                    );
                  },
                ),
    );
  }
}
