import 'package:json_annotation/json_annotation.dart';

part 'invoices.g.dart';

@JsonSerializable()
class Invoices {
  final int id;
  final String date;
  final String customerName;
  final String refName;
  final String vehicleNum;
  final double itemCount;
  final double totalAmount;
  final double disValue;
  final double disPrace;
  final double netAmount;
  final String pMethode;
  final double pAmount;
  final double deuAmount;

  Invoices(
      {required this.id,
      required this.date,
      required this.customerName,
      required this.refName,
      required this.vehicleNum,
      required this.itemCount,
      required this.totalAmount,
      required this.disValue,
      required this.disPrace,
      required this.netAmount,
      required this.pMethode,
      required this.pAmount,
      required this.deuAmount});

  factory Invoices.fromJson(Map<String, Object?> json) => _$InvoicesFromJson(json);

  Map<String, Object?> toJson() => _$InvoicesToJson(this);
}
