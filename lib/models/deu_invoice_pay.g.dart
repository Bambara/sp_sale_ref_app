// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deu_invoice_pay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeuInvoicePay _$DeuInvoicePayFromJson(Map<String, dynamic> json) => DeuInvoicePay(
      id: json['id'] as String,
      invoiceId: json['invoiceId'] as String,
      customerName: json['customerName'] as String,
      payedDate: json['payedDate'] as String,
      payedAmount: (json['payedAmount'] as num).toDouble(),
      deuAmount: (json['deuAmount'] as num).toDouble(),
      refName: json['refName'] as String,
    );

Map<String, dynamic> _$DeuInvoicePayToJson(DeuInvoicePay instance) => <String, dynamic>{
      'id': instance.id,
      'invoiceId': instance.invoiceId,
      'customerName': instance.customerName,
      'payedDate': instance.payedDate,
      'payedAmount': instance.payedAmount,
      'deuAmount': instance.deuAmount,
      'refName': instance.refName,
    };
