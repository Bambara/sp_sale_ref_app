import 'package:json_annotation/json_annotation.dart';

part 'invoice_deu.g.dart';

@JsonSerializable()
class InvoiceDeu {
  final String id;
  final String date;
  final int invoiceNumber;
  final String customerName;
  final String refName;
  final double deuAmount;
  final String status;

  InvoiceDeu(
      {required this.id, required this.date, required this.invoiceNumber, required this.refName, required this.customerName, required this.deuAmount, required this.status});

  factory InvoiceDeu.fromJson(Map<String, Object?> json) => _$InvoiceDeuFromJson(json);

  Map<String, Object?> toJson() => _$InvoiceDeuToJson(this);
}
