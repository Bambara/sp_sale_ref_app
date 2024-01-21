import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sp_sale_ref_app/api/pdf/invoice_view/invoice_api.dart';

import '../../../models/invoice_items.dart';

class PreInvoiceView extends StatefulWidget {
  const PreInvoiceView(
      {Key? key,
      required this.allProducts,
      required this.invoiceNumber,
      required this.invoiceDate,
      required this.customerName,
      required this.refName,
      required this.totalAmount,
      required this.itemCount,
      required this.discountValue,
      required this.discountPra,
      required this.netAmount,
      required this.payedAmount,
      required this.deuAmount,
      required this.paymentMethode})
      : super(key: key);
  static const routeName = '/invoice_views_view';
  final List<InvoiceItems> allProducts;
  final int invoiceNumber;
  final String invoiceDate;
  final String customerName;
  final String refName;
  final double itemCount;
  final double totalAmount;
  final double discountValue;
  final double discountPra;
  final double netAmount;
  final double payedAmount;
  final double deuAmount;
  final String paymentMethode;

  @override
  State<PreInvoiceView> createState() => _PreInvoiceViewState();
}

class _PreInvoiceViewState extends State<PreInvoiceView> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments as PreInvoiceView;
    return Scaffold(
      body: buildPdfPreview(arguments),
    );
  }

  PdfPreview buildPdfPreview(PreInvoiceView arguments) {
    var view;

    try {
      view = PdfPreview(
        // pageFormats: const {'roll 58mm': PdfPageFormat(58 * PdfPageFormat.mm, 80 * PdfPageFormat.mm)},
        pageFormats: const {'Roll 57mm': PdfPageFormat(58 * PdfPageFormat.mm, 141 * PdfPageFormat.mm)},
        build: (pageFormat) async {
          return InvoiceAPI.generateCustomerInvoice(
            arguments.allProducts,
            arguments.invoiceNumber,
            arguments.invoiceDate,
            arguments.customerName,
            arguments.refName,
            arguments.itemCount.round(),
            arguments.totalAmount,
            arguments.discountValue,
            arguments.discountPra,
            arguments.netAmount,
            arguments.payedAmount,
            arguments.deuAmount,
            arguments.paymentMethode,
          );
        },
      );
    } catch (e) {
      Logger().i(e.toString());
    }
    return view;
  }
}
