// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleStock _$VehicleStockFromJson(Map<String, dynamic> json) => VehicleStock(
      stockId: json['stockId'] as String,
      vehicleNum: json['vehicleNum'] as String,
      pCode: json['pCode'] as String,
      pName: json['pName'] as String,
      pImage: json['pImage'] as String,
      salePrice: (json['salePrice'] as num).toDouble(),
      qty: (json['qty'] as num).toDouble(),
    );

Map<String, dynamic> _$VehicleStockToJson(VehicleStock instance) => <String, dynamic>{
      'stockId': instance.stockId,
      'vehicleNum': instance.vehicleNum,
      'pCode': instance.pCode,
      'pName': instance.pName,
      'pImage': instance.pImage,
      'salePrice': instance.salePrice,
      'qty': instance.qty,
    };
