// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['id'] as String,
      productCode: json['productCode'] as String,
      barCode: json['barCode'] as String,
      productName: json['productName'] as String,
      salePrice: (json['salePrice'] as num).toDouble(),
      itemType: json['itemType'] as String,
      productImage: json['productImage'] as String,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'productCode': instance.productCode,
      'barCode': instance.barCode,
      'productName': instance.productName,
      'salePrice': instance.salePrice,
      'itemType': instance.itemType,
      'productImage': instance.productImage,
    };
