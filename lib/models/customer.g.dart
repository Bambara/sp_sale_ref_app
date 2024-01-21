// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      fullName: json['fullName'] as String,
      nic: json['nic'] as String,
      bussines_name: json['bussines_name'] as String,
      bussines_name_address: json['bussines_name_address'] as String,
      mobile_num: json['mobile_num'] as String,
      customer_type: json['customer_type'] as String,
      discount_type: json['discount_type'] as String,
      refName: json['refName'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'fullName': instance.fullName,
      'nic': instance.nic,
      'bussines_name': instance.bussines_name,
      'bussines_name_address': instance.bussines_name_address,
      'mobile_num': instance.mobile_num,
      'customer_type': instance.customer_type,
      'discount_type': instance.discount_type,
      'refName': instance.refName,
      'status': instance.status,
    };
