import 'package:json_annotation/json_annotation.dart';

part 'vehicle_load.g.dart';

@JsonSerializable()
class VehicleLoad {
  VehicleLoad({required this.id, required this.vehicleNumber, required this.refName, required this.loadDate});

  final String id;
  final String vehicleNumber;
  final String refName;
  final String loadDate;

  factory VehicleLoad.fromJson(Map<String, Object?> json) => _$VehicleLoadFromJson(json);

  Map<String, Object?> toJson() => _$VehicleLoadToJson(this);
}
