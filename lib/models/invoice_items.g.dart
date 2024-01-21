// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItems _$InvoiceItemsFromJson(Map<String, dynamic> json) => InvoiceItems(
      invoiceId: json['invoiceId'] as String,
      productCode: json['productCode'] as String,
      productName: json['productName'] as String,
      salePrice: (json['salePrice'] as num).toDouble(),
      discountVal: (json['discountVal'] as num).toDouble(),
      qty: (json['qty'] as num).toDouble(),
      aveQty: (json['aveQty'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceItemsToJson(InvoiceItems instance) => <String, dynamic>{
      'invoiceId': instance.invoiceId,
      'productCode': instance.productCode,
      'productName': instance.productName,
      'salePrice': instance.salePrice,
      'discountVal': instance.discountVal,
      'qty': instance.qty,
      'aveQty': instance.aveQty,
    };
