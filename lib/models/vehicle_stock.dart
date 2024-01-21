import 'package:json_annotation/json_annotation.dart';

part 'vehicle_stock.g.dart';

@JsonSerializable()
class VehicleStock {
  final String stockId;
  final String vehicleNum;
  final String pCode;
  final String pName;
  final String pImage;
  final double salePrice;
  final double qty;

  VehicleStock({required this.stockId, required this.vehicleNum, required this.pCode, required this.pName, required this.pImage, required this.salePrice, required this.qty});

  factory VehicleStock.fromJson(Map<String, Object?> json) => _$VehicleStockFromJson(json);

  Map<String, Object?> toJson() => _$VehicleStockToJson(this);
}
