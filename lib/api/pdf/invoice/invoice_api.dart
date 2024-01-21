import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sp_sale_ref_app/data/login_session.dart';

import '../../../models/invoice_items.dart';
import 'invoice_custome_row.dart';

class InvoiceAPI {
  static Future<Uint8List> generateCustomerInvoice(
    List<InvoiceItems> invoiceItems,
    int invoiceNumber,
    String invoiceDate,
    String customerName,
    int itemCount,
    double totalAmount,
    double discountValue,
    double discountPra,
    double netAmount,
    double payedAmount,
    double deuAmount,
    double returnAmount,
    String paymentMethode,
  ) async {
    final invoicePDF = pw.Document();
    final List<InvoiceCustomRow> elements = [
      for (var product in invoiceItems)
        InvoiceCustomRow(product.productName, product.salePrice.toStringAsFixed(2), product.qty.toStringAsFixed(0), (product.salePrice * product.qty).toStringAsFixed(2),
            (product.discountVal).toStringAsFixed(2)),
    ];
    final image = (await rootBundle.load("assets/swarna-logo.jpg")).buffer.asUint8List();

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

    /*invoicePDF.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(58 * PdfPageFormat.mm, 800 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              invoiceLogo(image),
              address(),
              pw.SizedBox(height: 5),
              invoiceNumberInfo(invoiceNumber.toString(), customerName, invoiceDate),
              pw.SizedBox(height: 3),
              pw.Divider(height: 7),
              rowHeaders(),
              pw.Divider(height: 7),
              itemColumn(elements),
              pw.Divider(height: 7, thickness: 0.5),
              values(itemCount, totalAmount, discountValue, discountPra, paymentMethode, payedAmount, returnAmount, deuAmount),
              pw.Divider(height: 7, thickness: 0.5),
              footer(),
              pw.Divider(height: 10, thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
              pw.SizedBox(height: 5),
              */ /*invoiceNumberInfo(invoiceNumber.toString(), customerName, invoiceDate),
            pw.SizedBox(height: 3),
            pw.Divider(height: 7),
            values(itemCount, totalAmount, discountValue, discountPra, paymentMethode, payedAmount, deuAmount),
            pw.Divider(height: 7, thickness: 0.5, borderStyle: pw.BorderStyle.dashed),*/ /*
            ],
          );
        },
      ),
    );*/

    invoicePDF.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat(
          58 * PdfPageFormat.mm,
          141 * PdfPageFormat.mm,
          marginLeft: 0.5 * PdfPageFormat.mm,
          marginBottom: 0 * PdfPageFormat.mm,
          marginRight: 0.5 * PdfPageFormat.mm,
          marginTop: 1.0 * PdfPageFormat.mm,
        ),
        /*header: (context) {
          return pw.Column(children: [
            address(),
            pw.SizedBox(height: 5),
            invoiceNumberInfo(invoiceNumber.toString(), customerName, refName, invoiceDate),
            pw.SizedBox(height: 3),
            pw.Divider(height: 7),
          ]);
        },*/
        /*build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.center, mainAxisSize: pw.MainAxisSize.min, children: [
              itemColumn(elements),
              pw.Divider(height: 10, thickness: 0.5),
              //values(totalInvoices, cashInvoices, creditInvoices, chequeInvoices, dailySale, dailyCashSale, dailyCreditSale, dailyChequeSale),
            ]),
          ];
        },*/
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: [
            invoiceLogo(image),
            address(),
            pw.SizedBox(height: 5),
            invoiceNumberInfo(invoiceNumber.toString(), customerName, invoiceDate),
            pw.SizedBox(height: 3),
            pw.Divider(height: 7),
          ]),
          // _topHeaderLayout(),
          rowHeaders(),
          pw.Divider(height: 7),
          // for (int i = 0; i < invoiceItems.length; i++) _productLayout(invoiceItems[i], i + 1),
          itemColumn(elements),
          pw.Divider(height: 7, thickness: 0.5),
          values(itemCount, totalAmount, discountValue, discountPra, paymentMethode, payedAmount, returnAmount, deuAmount),
          pw.Divider(height: 7, thickness: 0.5),
          footer(),
        ],
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
            pw.Row(children: [
              pw.Text("Pahala Galkandegama, Punewa", style: const pw.TextStyle(fontSize: 11)),
            ]),
            pw.Row(children: [
              pw.Text("0761357747 / 0718106264", style: const pw.TextStyle(fontSize: 11)),
            ])
          ],
        ),
      ],
    );
  }

  static pw.Widget invoiceNumberInfo(String invoiceNumber, String customerName, String date) {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(children: [pw.Text("Invoice Num : ", style: const pw.TextStyle(fontSize: 10)), pw.Text(invoiceNumber, style: const pw.TextStyle(fontSize: 10))]),
          pw.Row(children: [pw.Text("Date : ", style: const pw.TextStyle(fontSize: 10)), pw.Text(date, style: const pw.TextStyle(fontSize: 10))]),
        ],
      ),
      pw.SizedBox(height: 5),
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
      ]),
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
      int itemCount, double totalAmount, double discountValue, double discountPra, String paymentMethode, double payedAmount, double returnAmount, double deuAmount) {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 15),
        pw.Expanded(child: pw.Text('Item Count :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(itemCount.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 15),
        pw.Expanded(child: pw.Text('Total Amount :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(totalAmount.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 15),
        pw.Expanded(child: pw.Text('Dis Value :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(discountValue.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 15),
        pw.Expanded(child: pw.Text('Dis Prec % :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(discountPra.toStringAsFixed(2), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 15),
        pw.Expanded(child: pw.Text('Pay Methode :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(paymentMethode, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 15),
        pw.Expanded(child: pw.Text('Return Amount :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(returnAmount.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 15),
        pw.Expanded(child: pw.Text('Payed Amount :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(payedAmount.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 15),
        pw.Expanded(child: pw.Text('Deu Amount :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(deuAmount.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ])
    ]);
  }

  /*static pw.Widget footer() {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
      pw.SizedBox(height: 2),
      pw.Text("Thanks for your trust !", style: const pw.TextStyle(fontSize: 13)),
      pw.SizedBox(height: 5),
      pw.Text("Software by Bi Helix(pvt) LTD", style: const pw.TextStyle(fontSize: 9)),
      pw.Text("(0777675093 / 0707675093)", style: const pw.TextStyle(fontSize: 9)),
      pw.SizedBox(height: 2),
    ]);
  }*/

  static pw.Widget footer() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
        pw.SizedBox(height: 2),
        pw.Text("Thanks for your trust !", style: const pw.TextStyle(fontSize: 13)),
        pw.SizedBox(height: 5),
        pw.Text("Software by Bi Helix(pvt) LTD", style: const pw.TextStyle(fontSize: 9)),
        pw.Text("(0777675093 / 0707675093)", style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(height: 2),
      ])
    ]);
  }

  static pw.Widget itemColumn(List<InvoiceCustomRow> elements) {
    return pw.Column(
      children: [
        for (var element in elements)
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            pw.SizedBox(height: 2),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
              pw.Expanded(child: pw.Text(element.itemName, textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 10))),
              pw.Expanded(child: pw.Text(element.itemPrice, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 10))),
            ]),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text(element.qty, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 10))),
                pw.Expanded(child: pw.Text(element.total, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
                pw.Expanded(child: pw.Text(element.disAmount, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
              ],
            ),
            pw.SizedBox(height: 2),
            pw.Divider(height: 7, borderStyle: pw.BorderStyle.dashed),
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
