import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final String id;
  final String productCode;
  final String barCode;
  final String productName;
  final double salePrice;
  final String itemType;
  final String productImage;

  Product(this.id, {required this.productCode, required this.barCode, required this.productName, required this.salePrice, required this.itemType, required this.productImage});

  factory Product.fromJson(Map<String, Object?> json) => _$ProductFromJson(json);

  Map<String, Object?> toJson() => _$ProductToJson(this);
}
