import 'package:json_annotation/json_annotation.dart';

part 'invoice_items.g.dart';

@JsonSerializable()
class InvoiceItems {
  final String invoiceId;
  final String productCode;
  final String productName;
  final double salePrice;
  final double discountVal;
  final double qty;
  final double aveQty;

  InvoiceItems(
      {required this.invoiceId,
      required this.productCode,
      required this.productName,
      required this.salePrice,
      required this.discountVal,
      required this.qty,
      required this.aveQty});

  factory InvoiceItems.fromJson(Map<String, Object?> json) => _$InvoiceItemsFromJson(json);

  Map<String, Object?> toJson() => _$InvoiceItemsToJson(this);
}
