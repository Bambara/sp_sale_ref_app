// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_load.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleLoad _$VehicleLoadFromJson(Map<String, dynamic> json) => VehicleLoad(
      id: json['id'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      refName: json['refName'] as String,
      loadDate: json['loadDate'] as String,
    );

Map<String, dynamic> _$VehicleLoadToJson(VehicleLoad instance) => <String, dynamic>{
      'id': instance.id,
      'vehicleNumber': instance.vehicleNumber,
      'refName': instance.refName,
      'loadDate': instance.loadDate,
    };
