import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../models/deu_invoice_pay.dart';
import 'cash_collect_summary_ref_api.dart';

class CashCollectSummaryRefView extends StatefulWidget {
  const CashCollectSummaryRefView({
    Key? key,
    required this.allCollections,
    required this.refName,
    required this.date,
    required this.totalInvoices,
    required this.totalCashCollect,
    required this.totalDeu,
  }) : super(key: key);
  static const routeName = '/ref_cash_collect_summary_view';
  final List<DeuInvoicePay> allCollections;
  final String refName;
  final String date;
  final int totalInvoices;
  final double totalCashCollect;
  final double totalDeu;

  @override
  State<CashCollectSummaryRefView> createState() => _CashCollectSummaryRefViewState();
}

class _CashCollectSummaryRefViewState extends State<CashCollectSummaryRefView> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments as CashCollectSummaryRefView;
    return Scaffold(
      body: buildPdfPreview(arguments),
    );
  }

  PdfPreview buildPdfPreview(CashCollectSummaryRefView arguments) {
    var view;

    try {
      view = PdfPreview(
        // pageFormats: const {'roll 58mm': PdfPageFormat(58 * PdfPageFormat.mm, 80 * PdfPageFormat.mm)},
        pageFormats: const {'Roll 57mm': PdfPageFormat(58 * PdfPageFormat.mm, 800 * PdfPageFormat.mm)},
        build: (pageFormat) async {
          return CashCollectSummaryRefAPI.generateCustomerInvoice(
            arguments.allCollections,
            arguments.refName,
            arguments.date,
            arguments.totalInvoices,
            arguments.totalCashCollect,
            arguments.totalDeu,
          );
        },
      );
    } catch (e) {
      Logger().i(e.toString());
    }
    return view;
  }
}
