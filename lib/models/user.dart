import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String emp_id;
  final String user_name;
  final String password;
  final String email;
  final String contact;
  final String user_type_id;

  User({required this.emp_id, required this.user_name, required this.password, required this.email, required this.contact, required this.user_type_id});

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  Map<String, Object?> toJson() => _$UserToJson(this);
}
