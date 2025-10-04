// lib/screens/recommendation/recommended_products_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/models/product.dart';
import 'package:initial_bf/widgets/cards/product_card.dart'; // ⭐ ProductCard 임포트

class RecommendedProductsScreen extends StatefulWidget {
  const RecommendedProductsScreen({super.key});

  @override
  State<RecommendedProductsScreen> createState() =>
      _RecommendedProductsScreenState();
}

class _RecommendedProductsScreenState extends State<RecommendedProductsScreen> {
  // 상태 변수들
  bool _isLoading = true; // 데이터 로딩 상태
  List<Product> _allProducts = []; // 모든 제품 원본 데이터
  List<Product> _filteredProducts = []; // 현재 필터링된 제품 데이터
  final List<String> _categories = ['전체', '스킨케어', '베이스', '색조'];
  String _selectedCategory = '전체'; // 현재 선택된 카테고리

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // 화면이 처음 로드될 때 제품 데이터 가져오기
  }

  // 💡 [핵심 로직] 백엔드 추천 API 연동 (시뮬레이션)
  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    // 2초간 로딩 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    // 더미 데이터 생성
    final dummyProducts = [
      Product(
          id: 1,
          name: '시카풀 앰플',
          brand: '뷰파 코스메틱',
          imageUrl: 'https://picsum.photos/id/10/200/200',
          safetyScore: 4.8,
          isBookmarked: false),
      Product(
          id: 2,
          name: '글로우 파운데이션',
          brand: '컬러랩',
          imageUrl: 'https://picsum.photos/id/20/200/200',
          safetyScore: 4.5,
          isBookmarked: true),
      Product(
          id: 3,
          name: '워터리 선크림',
          brand: '뷰파 코스메틱',
          imageUrl: 'https://picsum.photos/id/30/200/200',
          safetyScore: 4.9,
          isBookmarked: false),
      Product(
          id: 4,
          name: '벨벳 틴트 #가을로즈',
          brand: '컬러랩',
          imageUrl: 'https://picsum.photos/id/40/200/200',
          safetyScore: 4.2,
          isBookmarked: false),
    ];

    setState(() {
      _allProducts = dummyProducts;
      _filterProducts(); // 초기 필터링
      _isLoading = false;
    });
  }

  // 💡 [핵심 로직] 카테고리 필터링
  void _filterProducts() {
    if (_selectedCategory == '전체') {
      _filteredProducts = _allProducts;
    } else {
      // TODO: 실제 데이터에는 'category' 필드가 있어야 합니다.
      _filteredProducts = _allProducts.where((p) {
        if (_selectedCategory == '스킨케어') return p.id.isOdd;
        if (_selectedCategory == '베이스' || _selectedCategory == '색조')
          return p.id.isEven;
        return false;
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맞춤 추천 제품'),
      ),
      body: Column(
        children: [
          // 1. 카테고리 필터 탭
          _buildCategoryTabs(),
          const Divider(height: 1, thickness: 1),

          // 2. 제품 카드 리스트
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator()) // 로딩 중일 때
                : _filteredProducts.isEmpty
                    ? const Center(child: Text('추천 제품이 없습니다.')) // 제품이 없을 때
                    : ListView.builder(
                        // 제품이 있을 때
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          // ⭐ _buildProductCard(product) 대신 ProductCard 위젯 사용
                          return ProductCard(
                            product: product,
                            onBookmarkPressed: () {
                              // 북마크 버튼 클릭 시 로직
                              setState(() {
                                final originalIndex = _allProducts
                                    .indexWhere((p) => p.id == product.id);
                                if (originalIndex != -1) {
                                  final updatedProduct =
                                      _allProducts[originalIndex].copyWith(
                                          isBookmarked: !product.isBookmarked);
                                  _allProducts[originalIndex] = updatedProduct;
                                  _filterProducts();
                                }
                              });
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // 카테고리 탭 UI
  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                    _filterProducts();
                  });
                }
              },
              backgroundColor: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.grey[200],
              selectedColor: AppColors.primary.withOpacity(0.2),
              labelStyle: AppTextStyles.body.copyWith(
                color: isSelected ? AppColors.primary : AppColors.text,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: StadiumBorder(
                  side: BorderSide(
                      color:
                          isSelected ? AppColors.primary : Colors.transparent)),
            ),
          );
        },
      ),
    );
  }

  // ❌ 이제 _buildProductCard 헬퍼 함수는 ProductCard.dart 파일로 분리되었으므로 삭제합니다.
}
