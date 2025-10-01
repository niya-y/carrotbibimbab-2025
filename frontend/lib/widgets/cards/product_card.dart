// lib/widgets/cards/product_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initial_bf/constants/app_colors.dart';
import 'package:initial_bf/constants/app_text_styles.dart';
import 'package:initial_bf/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onBookmarkPressed; // 북마크 버튼 클릭 시 호출될 함수

  const ProductCard({
    super.key,
    required this.product,
    required this.onBookmarkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 탭하면 해당 제품의 상세 페이지로 이동
        context.go('/product/${product.id}');
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // 제품 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // 제품 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.brand,
                        style:
                            AppTextStyles.body.copyWith(color: AppColors.grey)),
                    const SizedBox(height: 4),
                    Text(product.name,
                        style: AppTextStyles.headline4,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(product.safetyScore.toString(),
                            style: AppTextStyles.body
                                .copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              // 북마크 버튼
              IconButton(
                icon: Icon(
                  product.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color:
                      product.isBookmarked ? AppColors.primary : AppColors.grey,
                ),
                onPressed: onBookmarkPressed, // 상위 위젯에서 전달받은 함수 호출
              ),
            ],
          ),
        ),
      ),
    );
  }
}
