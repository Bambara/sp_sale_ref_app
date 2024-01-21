// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      nic: json['nic'] as String,
      mobile_num: json['mobile_num'] as String,
      email_address: json['email_address'] as String,
      address: json['address'] as String,
      join_date: json['join_date'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'fname': instance.fname,
      'lname': instance.lname,
      'nic': instance.nic,
      'mobile_num': instance.mobile_num,
      'email_address': instance.email_address,
      'address': instance.address,
      'join_date': instance.join_date,
      'status': instance.status,
    };
