import 'package:json_annotation/json_annotation.dart';

// This doesn't exist yet...! See "Next Steps"
part 'employee.g.dart';

@JsonSerializable()
class Employee {
  Employee(
      {required this.fname,
      required this.lname,
      required this.nic,
      required this.mobile_num,
      required this.email_address,
      required this.address,
      required this.join_date,
      required this.status});

  factory Employee.fromJson(Map<String, Object?> json) => _$EmployeeFromJson(json);

  final String fname;
  final String lname;
  final String nic;
  final String mobile_num;
  final String email_address;
  final String address;
  final String join_date;
  final String status;

  Map<String, Object?> toJson() => _$EmployeeToJson(this);
}
