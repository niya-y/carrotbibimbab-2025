// lib/screens/recommendation/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // 이미지 슬라이더
import 'package:url_launcher/url_launcher.dart'; // 외부 링크
import 'package:initial_bf/models/product_detail.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = true;
  ProductDetail? _productDetail;

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  // 💡 [핵심 로직] 백엔드 API 연동 (시뮬레이션)
  Future<void> _fetchProductDetail() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1)); // 1초 로딩 시뮬레이션

    // TODO: 실제로는 Supabase에서 productId를 사용하여 제품 상세 정보를 가져옵니다.
    // final response = await supabase.from('products').select('*, ingredients(*)').eq('id', widget.productId).single();
    // final productDetail = ProductDetail.fromJson(response);

    // 더미 데이터 생성
    final dummyDetail = ProductDetail(
      id: int.parse(widget.productId),
      name: '시카풀 앰플',
      brand: '뷰파 코스메틱',
      imageUrls: [
        'https://picsum.photos/id/10/400/400',
        'https://picsum.photos/id/11/400/400',
        'https://picsum.photos/id/12/400/400',
      ],
      safetyScore: 4.8,
      isBookmarked: false,
      description:
          '민감해진 피부를 위한 긴급 진정 솔루션! 병풀 추출물이 80% 함유되어 외부 자극으로부터 피부를 보호하고 빠르게 진정시켜줍니다.',
      ingredients: [
        Ingredient(name: '병풀추출물', isGoodForUser: true, isBadForUser: false),
        Ingredient(name: '에탄올', isGoodForUser: false, isBadForUser: true),
        Ingredient(name: '글리세린', isGoodForUser: false, isBadForUser: false),
      ],
      purchaseUrl: 'https://www.google.com', // 임시 구매처 링크
    );

    setState(() {
      _productDetail = dummyDetail;
      _isLoading = false;
    });
  }

  // 💡 [핵심 로직] 외부 링크 열기
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('링크를 열 수 없습니다: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_productDetail?.name ?? '제품 상세'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _productDetail == null
              ? const Center(child: Text('제품 정보를 불러오지 못했습니다.'))
              : _buildProductDetails(),
      // 하단 고정 버튼
      bottomNavigationBar: _productDetail == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () => _launchURL(_productDetail!.purchaseUrl),
                child: const Text('구매처 보러가기', style: AppTextStyles.button),
              ),
            ),
    );
  }

  Widget _buildProductDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 제품 이미지 슬라이더
          if (_productDetail!.imageUrls.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 1,
                viewportFraction: 1.0,
                autoPlay: true,
              ),
              items: _productDetail!.imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(url,
                        fit: BoxFit.cover, width: double.infinity);
                  },
                );
              }).toList(),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. 기본 정보
                Text(_productDetail!.brand,
                    style: AppTextStyles.body.copyWith(color: AppColors.grey)),
                const SizedBox(height: 8),
                Text(_productDetail!.name, style: AppTextStyles.headline2),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(_productDetail!.safetyScore.toString(),
                        style: AppTextStyles.headline4),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        _productDetail!.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: _productDetail!.isBookmarked
                            ? AppColors.primary
                            : AppColors.grey,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          // TODO: 북마크 상태 변경 로직 (Supabase 연동)
                          _productDetail = _productDetail!.copyWith(
                              isBookmarked: !_productDetail!.isBookmarked);
                        });
                      },
                    ),
                  ],
                ),
                const Divider(height: 40),

                // 3. 상세 설명
                Text('제품 설명', style: AppTextStyles.headline4),
                const SizedBox(height: 12),
                Text(_productDetail!.description, style: AppTextStyles.body),
                const Divider(height: 40),

                // 4. 사용자 기반 안전성 분석 상세
                Text('나를 위한 성분 분석', style: AppTextStyles.headline4),
                const SizedBox(height: 12),
                for (var ingredient in _productDetail!.ingredients)
                  ListTile(
                    leading: Icon(
                      ingredient.isGoodForUser
                          ? Icons.check_circle_outline
                          : ingredient.isBadForUser
                              ? Icons.dangerous_outlined
                              : Icons.info_outline,
                      color: ingredient.isGoodForUser
                          ? Colors.green
                          : ingredient.isBadForUser
                              ? Colors.red
                              : AppColors.grey,
                    ),
                    title: Text(ingredient.name),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
