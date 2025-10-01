// lib/models/product_detail.dart
import 'package:freezed_annotation/freezed_annotation.dart'; // ⭐ 이 줄이 가장 중요합니다!

part 'product_detail.freezed.dart';
part 'product_detail.g.dart';

@freezed
class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required int id,
    required String name,
    required String brand,
    required List<String> imageUrls,
    required double safetyScore,
    required bool isBookmarked,
    required String description,
    required List<Ingredient> ingredients,
    required String purchaseUrl,
  }) = _ProductDetail;

  factory ProductDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailFromJson(json);
}

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String name,
    required bool isGoodForUser,
    required bool isBadForUser,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}
