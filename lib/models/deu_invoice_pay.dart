import 'package:json_annotation/json_annotation.dart';

part 'deu_invoice_pay.g.dart';

@JsonSerializable()
class DeuInvoicePay {
  DeuInvoicePay(
      {required this.id,
      required this.invoiceId,
      required this.customerName,
      required this.payedDate,
      required this.payedAmount,
      required this.deuAmount,
      required this.refName});

  final String id;
  final String invoiceId;
  final String customerName;
  final String payedDate;
  final double payedAmount;
  final double deuAmount;
  final String refName;

  factory DeuInvoicePay.fromJson(Map<String, Object?> json) => _$DeuInvoicePayFromJson(json);

  Map<String, Object?> toJson() => _$DeuInvoicePayToJson(this);
}
