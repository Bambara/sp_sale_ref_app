import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle {
  final String vehicleNumber;
  final String vehicleType;
  final String fuelType;
  final String frontImage;
  final String backImage;

  Vehicle({required this.vehicleNumber, required this.vehicleType, required this.fuelType, required this.frontImage, required this.backImage});

  factory Vehicle.fromJson(Map<String, Object?> json) => _$VehicleFromJson(json);

  Map<String, Object?> toJson() => _$VehicleToJson(this);
}
