// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductDetailImpl _$$ProductDetailImplFromJson(Map<String, dynamic> json) =>
    _$ProductDetailImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      brand: json['brand'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      safetyScore: (json['safetyScore'] as num).toDouble(),
      isBookmarked: json['isBookmarked'] as bool,
      description: json['description'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      purchaseUrl: json['purchaseUrl'] as String,
    );

Map<String, dynamic> _$$ProductDetailImplToJson(_$ProductDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'imageUrls': instance.imageUrls,
      'safetyScore': instance.safetyScore,
      'isBookmarked': instance.isBookmarked,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'purchaseUrl': instance.purchaseUrl,
    };

_$IngredientImpl _$$IngredientImplFromJson(Map<String, dynamic> json) =>
    _$IngredientImpl(
      name: json['name'] as String,
      isGoodForUser: json['isGoodForUser'] as bool,
      isBadForUser: json['isBadForUser'] as bool,
    );

Map<String, dynamic> _$$IngredientImplToJson(_$IngredientImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isGoodForUser': instance.isGoodForUser,
      'isBadForUser': instance.isBadForUser,
    };
