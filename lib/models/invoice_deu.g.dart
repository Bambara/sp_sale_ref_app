// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_deu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceDeu _$InvoiceDeuFromJson(Map<String, dynamic> json) => InvoiceDeu(
      id: json['id'] as String,
      date: json['date'] as String,
      invoiceNumber: json['invoiceNumber'] as int,
      refName: json['refName'] as String,
      customerName: json['customerName'] as String,
      deuAmount: (json['deuAmount'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$InvoiceDeuToJson(InvoiceDeu instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'invoiceNumber': instance.invoiceNumber,
      'customerName': instance.customerName,
      'refName': instance.refName,
      'deuAmount': instance.deuAmount,
      'status': instance.status,
    };
