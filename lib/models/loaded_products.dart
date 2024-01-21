import 'package:json_annotation/json_annotation.dart';

part 'loaded_products.g.dart';

@JsonSerializable()
class LoadedProducts {
  final String loadId;
  final String productsCode;
  final String productName;
  final String productImage;
  final double salePrice;
  final double qty;

  LoadedProducts({required this.loadId, required this.productsCode, required this.productName, required this.productImage, required this.salePrice, required this.qty});

  factory LoadedProducts.fromJson(Map<String, Object?> json) => _$LoadedProductsFromJson(json);

  Map<String, Object?> toJson() => _$LoadedProductsToJson(this);
}
