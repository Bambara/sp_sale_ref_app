// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoices _$InvoicesFromJson(Map<String, dynamic> json) => Invoices(
      id: json['id'] as int,
      date: json['date'] as String,
      customerName: json['customerName'] as String,
      refName: json['refName'] as String,
      vehicleNum: json['vehicleNum'] as String,
      itemCount: (json['itemCount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      disValue: (json['disValue'] as num).toDouble(),
      disPrace: (json['disPrace'] as num).toDouble(),
      netAmount: (json['netAmount'] as num).toDouble(),
      pMethode: json['pMethode'] as String,
      pAmount: (json['pAmount'] as num).toDouble(),
      deuAmount: (json['deuAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoicesToJson(Invoices instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'customerName': instance.customerName,
      'refName': instance.refName,
      'vehicleNum': instance.vehicleNum,
      'itemCount': instance.itemCount,
      'totalAmount': instance.totalAmount,
      'disValue': instance.disValue,
      'disPrace': instance.disPrace,
      'netAmount': instance.netAmount,
      'pMethode': instance.pMethode,
      'pAmount': instance.pAmount,
      'deuAmount': instance.deuAmount,
    };
