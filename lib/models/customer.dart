import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  Customer({
    required this.fullName,
    required this.nic,
    required this.bussines_name,
    required this.bussines_name_address,
    required this.mobile_num,
    required this.customer_type,
    required this.discount_type,
    required this.refName,
    required this.status,
  });

  final String fullName;
  final String nic;
  final String bussines_name;
  final String bussines_name_address;
  final String mobile_num;
  final String customer_type;
  final String discount_type;
  final String refName;
  final String status;

  factory Customer.fromJson(Map<String, Object?> json) => _$CustomerFromJson(json);

  Map<String, Object?> toJson() => _$CustomerToJson(this);
}
