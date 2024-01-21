// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      emp_id: json['emp_id'] as String,
      user_name: json['user_name'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      contact: json['contact'] as String,
      user_type_id: json['user_type_id'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'emp_id': instance.emp_id,
      'user_name': instance.user_name,
      'password': instance.password,
      'email': instance.email,
      'contact': instance.contact,
      'user_type_id': instance.user_type_id,
    };
