import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../models/invoice_deu.dart';
import 'deu_summary_admin_api.dart';

class DeuSummaryAdminView extends StatefulWidget {
  const DeuSummaryAdminView({
    Key? key,
    required this.allInvoices,
    required this.refName,
    required this.date,
  }) : super(key: key);
  static const routeName = '/admin_deu_summary_view';
  final List<InvoiceDeu> allInvoices;
  final String refName;
  final String date;

  @override
  State<DeuSummaryAdminView> createState() => _DeuSummaryAdminViewState();
}

class _DeuSummaryAdminViewState extends State<DeuSummaryAdminView> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments as DeuSummaryAdminView;
    return Scaffold(
      body: buildPdfPreview(arguments),
    );
  }

  PdfPreview buildPdfPreview(DeuSummaryAdminView arguments) {
    var view;

    try {
      view = PdfPreview(
        // pageFormats: const {'roll 58mm': PdfPageFormat(58 * PdfPageFormat.mm, 80 * PdfPageFormat.mm)},
        // pageFormats: const {'Roll 57mm': PdfPageFormat(58 * PdfPageFormat.mm, 800 * PdfPageFormat.mm)},
        pageFormats: const {
          'A4': PdfPageFormat(
            21.0 * PdfPageFormat.cm,
            29.7 * PdfPageFormat.cm,
            marginLeft: 1.5 * PdfPageFormat.cm,
            marginBottom: 0.5 * PdfPageFormat.cm,
            marginRight: 0.5 * PdfPageFormat.cm,
            marginTop: 1.0 * PdfPageFormat.cm,
          )
        },
        build: (pageFormat) async {
          return DueSummaryAdminAPI.generateDueSummary(
            arguments.allInvoices,
            arguments.refName,
            arguments.date,
          );
        },
      );
    } catch (e) {
      Logger().i(e.toString());
    }
    return view;
  }
}
