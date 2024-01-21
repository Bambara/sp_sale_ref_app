// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loaded_products.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadedProducts _$LoadedProductsFromJson(Map<String, dynamic> json) => LoadedProducts(
      loadId: json['loadId'] as String,
      productsCode: json['productsCode'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String,
      salePrice: (json['salePrice'] as num).toDouble(),
      qty: (json['qty'] as num).toDouble(),
    );

Map<String, dynamic> _$LoadedProductsToJson(LoadedProducts instance) => <String, dynamic>{
      'loadId': instance.loadId,
      'productsCode': instance.productsCode,
      'productName': instance.productName,
      'productImage': instance.productImage,
      'salePrice': instance.salePrice,
      'qty': instance.qty,
    };
