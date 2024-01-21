import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sp_sale_ref_app/models/invoices.dart';

import 'invoice_summary_ref_api.dart';

class InvoiceSummaryRefView extends StatefulWidget {
  const InvoiceSummaryRefView({
    Key? key,
    required this.allInvoices,
    required this.refName,
    required this.date,
    required this.totalInvoices,
    required this.cashInvoices,
    required this.creditInvoices,
    required this.chequeInvoices,
    required this.dailySale,
    required this.dailyCashSale,
    required this.dailyCreditSale,
    required this.dailyChequeSale,
  }) : super(key: key);
  static const routeName = '/ref_invoice_summary_view';
  final List<Invoices> allInvoices;
  final String refName;
  final String date;
  final int totalInvoices;
  final int cashInvoices;
  final int creditInvoices;
  final int chequeInvoices;
  final double dailySale;
  final double dailyCashSale;
  final double dailyCreditSale;
  final double dailyChequeSale;

  @override
  State<InvoiceSummaryRefView> createState() => _InvoiceSummaryRefViewState();
}

class _InvoiceSummaryRefViewState extends State<InvoiceSummaryRefView> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments as InvoiceSummaryRefView;
    return Scaffold(
      body: buildPdfPreview(arguments),
    );
  }

  PdfPreview buildPdfPreview(InvoiceSummaryRefView arguments) {
    var view;

    try {
      view = PdfPreview(
        // pageFormats: const {'roll 58mm': PdfPageFormat(58 * PdfPageFormat.mm, 80 * PdfPageFormat.mm)},
        pageFormats: const {'Roll 57mm': PdfPageFormat(58 * PdfPageFormat.mm, 800 * PdfPageFormat.mm)},
        build: (pageFormat) async {
          return InvoiceSummaryRefAPI.generateCustomerInvoice(
            arguments.allInvoices,
            arguments.refName,
            arguments.date,
            arguments.totalInvoices,
            arguments.cashInvoices,
            arguments.creditInvoices,
            arguments.chequeInvoices,
            arguments.dailySale,
            arguments.dailyCashSale,
            arguments.dailyCreditSale,
            arguments.dailyChequeSale,
          );
        },
      );
    } catch (e) {
      Logger().i(e.toString());
    }
    return view;
  }
}
