// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      vehicleNumber: json['vehicleNumber'] as String,
      vehicleType: json['vehicleType'] as String,
      fuelType: json['fuelType'] as String,
      frontImage: json['frontImage'] as String,
      backImage: json['backImage'] as String,
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'vehicleNumber': instance.vehicleNumber,
      'vehicleType': instance.vehicleType,
      'fuelType': instance.fuelType,
      'frontImage': instance.frontImage,
      'backImage': instance.backImage,
    };
