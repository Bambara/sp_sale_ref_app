import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sp_sale_ref_app/models/deu_invoice_pay.dart';

import 'cssr_custom_row.dart';

class CashCollectSummaryRefAPI {
  static Future<Uint8List> generateCustomerInvoice(
    List<DeuInvoicePay> deuInvoicePay,
    String refName,
    String date,
    int totalInvoices,
    double totalCashCollect,
    double totalDeu,
  ) async {
    final invoicePDF = pw.Document();
    final List<CSSRCustomRow> elements = [
      for (var invoice in deuInvoicePay)
        CSSRCustomRow(
          invoice.invoiceId.toString(),
          invoice.customerName,
          invoice.payedDate,
          invoice.payedAmount.toStringAsFixed(2),
          invoice.deuAmount.toStringAsFixed(2),
        ),
    ];
    final image = (await rootBundle.load("assets/flutter_explained_logo.jpg")).buffer.asUint8List();

    /*invoicePDF.addPage(
      pw.MultiPage(
        pageFormat: const PdfPageFormat(58 * PdfPageFormat.mm, 800 * PdfPageFormat.mm, marginLeft: 2, marginRight: 2),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.center, mainAxisSize: pw.MainAxisSize.min, children: [
              invoiceLogo(image),
              address(),
              pw.SizedBox(height: 3),
              invoiceNumberInfo(invoiceNumber.toString(), invoiceDate),
              pw.SizedBox(height: 3),
              pw.Divider(height: 7),
              rowHeaders(),
              itemColumn(elements),
              pw.Divider(height: 7, thickness: 0.5),
              values(itemCount, totalAmount, discountValue, discountPra, paymentMethode, payedAmount, deuAmount),
              pw.Divider(height: 7, thickness: 0.5),
              footer(),
            ]),
          ];
        },
      ),
    );*/

    invoicePDF.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(58 * PdfPageFormat.mm, 800 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.center, mainAxisSize: pw.MainAxisSize.min, children: [
            invoiceLogo(image),
            address(),
            pw.SizedBox(height: 5),
            invoiceNumberInfo(refName, date),
            pw.SizedBox(height: 3),
            pw.Divider(height: 7),
            // rowHeaders(),
            // pw.Divider(height: 7),
            itemColumn(elements),
            pw.Divider(height: 10, thickness: 0.5),
            values(totalInvoices, totalCashCollect, totalDeu),
            pw.Divider(height: 7, thickness: 0.5),
            // footer(),
          ]);
        },
      ),
    );

    return invoicePDF.save();
  }

  static pw.Widget invoiceLogo(Uint8List image) {
    return pw.Image(pw.MemoryImage(image), width: 48, height: 48, fit: pw.BoxFit.fill);
  }

  static pw.Widget address() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text("Swarna Products", style: const pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 2),
            pw.Row(children: [
              pw.Text("Daily Cash Collect Summary", style: const pw.TextStyle(fontSize: 11)),
            ]),
            pw.SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  static pw.Widget invoiceNumberInfo(String customerName, String date) {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(children: [pw.Text("Ref Name : ", style: const pw.TextStyle(fontSize: 10)), pw.Text(customerName, style: const pw.TextStyle(fontSize: 10))]),
          pw.Row(children: [pw.Text("Date : ", style: const pw.TextStyle(fontSize: 10)), pw.Text(date, style: const pw.TextStyle(fontSize: 10))]),
        ],
      ),
      /*pw.SizedBox(height: 5),
      pw.Row(children: [
        pw.Text("Customer : ", style: const pw.TextStyle(fontSize: 10)),
        pw.Text(customerName, style: const pw.TextStyle(fontSize: 10)),
      ]),
      pw.SizedBox(height: 5),
      pw.Row(children: [
        pw.Text("Ref Name : ", style: const pw.TextStyle(fontSize: 10)),
        pw.Text(LoginSession.refName, style: const pw.TextStyle(fontSize: 10)),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.Text("Ref Contact : ", style: const pw.TextStyle(fontSize: 10)),
        pw.Text(LoginSession.refContact, style: const pw.TextStyle(fontSize: 10)),
      ]),*/
    ]);
  }

  static pw.Widget rowHeaders() {
    return pw.Row(children: [
      pw.Expanded(child: pw.Text('Name', textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 10))),
      pw.Expanded(child: pw.Text('Price', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      pw.Expanded(child: pw.Text('Qty', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      pw.Expanded(child: pw.Text('Value', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      pw.Expanded(child: pw.Text('Dis.', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
    ]);
  }

  static pw.Widget values(
    int totalInvoices,
    double totalCashCollect,
    double totalDeu,
  ) {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 4),
        pw.Expanded(child: pw.Text('Total Invoices :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(totalInvoices.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 4),
        pw.Expanded(child: pw.Text('Cash Collect :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(totalCashCollect.toStringAsFixed(2), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 4),
        pw.Expanded(child: pw.Text('Total Deu :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(totalDeu.toStringAsFixed(2), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
    ]);
  }

  static pw.Widget footer() {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
      pw.SizedBox(height: 2),
      pw.Text("Thanks for your trust !", style: const pw.TextStyle(fontSize: 13)),
      pw.SizedBox(height: 5),
      pw.Text("Software by Bi Helix(pvt) LTD", style: const pw.TextStyle(fontSize: 9)),
      pw.Text("(0777675093 / 0707675093)", style: const pw.TextStyle(fontSize: 9)),
      pw.SizedBox(height: 2),
    ]);
  }

  static pw.Widget itemColumn(List<CSSRCustomRow> elements) {
    return pw.Column(
      children: [
        for (var element in elements)
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            pw.SizedBox(height: 2),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
              pw.Expanded(child: pw.Text(element.customerName, textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 10))),
              pw.Expanded(child: pw.Text(element.invoiceId, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
            ]),
            // pw.Divider(height: 2, borderStyle: pw.BorderStyle.dotted),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Payed Amount', textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 10))),
                pw.Expanded(child: pw.Text(element.payedAmount, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Deu Amount', textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 10))),
                pw.Expanded(child: pw.Text(element.deuAmount, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
              ],
            ),
            pw.SizedBox(height: 2),
            pw.Divider(height: 10, borderStyle: pw.BorderStyle.dashed),
          ])
      ],
    );
  }

  static Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getExternalStorageDirectory();
    Logger().i(output);
    var filePath = "${output?.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    // await OpenDocument.openDocument(filePath: filePath);
  }
}
