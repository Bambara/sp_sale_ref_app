import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'product.dart';

class CustomRow {
  final String itemName;
  final String itemPrice;
  final String amount;
  final String total;
  final String vat;

  CustomRow(this.itemName, this.itemPrice, this.amount, this.total, this.vat);
}

class PdfInvoiceService {
  Future<Uint8List> createHelloWorld() {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> createInvoice(List<Product> soldProducts) async {
    final pdf = pw.Document();

    final List<CustomRow> elements = [
      CustomRow("Item Name", "Item Price", "Amount", "Total", "Vat"),
      for (var product in soldProducts)
        CustomRow(
          product.name,
          product.price.toStringAsFixed(2),
          product.amount.toStringAsFixed(2),
          (product.price * product.amount).toStringAsFixed(2),
          (product.vatInPercent * product.price).toStringAsFixed(2),
        ),
      CustomRow("Sub Total", "", "", "", "${getSubTotal(soldProducts)} EUR"),
      CustomRow("Vat Total", "", "", "", "${getVatTotal(soldProducts)} EUR"),
      CustomRow("Vat Total", "", "", "", "${(double.parse(getSubTotal(soldProducts)) + double.parse(getVatTotal(soldProducts))).toStringAsFixed(2)} EUR")
    ];
    final image = (await rootBundle.load("assets/flutter_explained_logo.jpg")).buffer.asUint8List();

    // pdf.addPage(
    //   pw.MultiPage(
    //     build: (pw.Context context) {
    //       return <pw.Widget>[];
    //     },
    //     pageFormat: const PdfPageFormat(57, 80),
    //   ),
    // );
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(57, 80, marginAll: 2),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Image(pw.MemoryImage(image), width: 10, height: 10, fit: pw.BoxFit.cover),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("Customer Name", style: const pw.TextStyle(fontSize: 2)),
                      pw.Text("Customer Address", style: const pw.TextStyle(fontSize: 2)),
                      pw.Text("Customer City", style: const pw.TextStyle(fontSize: 2)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 2),
              itemColumn(elements),
              pw.SizedBox(height: 2),
              pw.Text("Thanks for your trust, and till the next time.", style: const pw.TextStyle(fontSize: 2)),
              pw.SizedBox(height: 2),
              pw.Text("Kind regards,", style: const pw.TextStyle(fontSize: 2)),
              pw.SizedBox(height: 2),
              pw.Text("Max Weber", style: const pw.TextStyle(fontSize: 2))
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Expanded itemColumn(List<CustomRow> elements) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          for (var element in elements)
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text(element.itemName, textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 2))),
                pw.Expanded(child: pw.Text(element.itemPrice, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 2))),
                pw.Expanded(child: pw.Text(element.amount, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 2))),
                pw.Expanded(child: pw.Text(element.total, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 2))),
                pw.Expanded(child: pw.Text(element.vat, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 2))),
              ],
            )
        ],
      ),
    );
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getApplicationDocumentsDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    // await OpenDocument.openDocument(filePath: filePath);
  }

  String getSubTotal(List<Product> products) {
    return products.fold(0.0, (double prev, element) => prev + (element.amount * element.price)).toStringAsFixed(2);
  }

  String getVatTotal(List<Product> products) {
    return products
        .fold(
          0.0,
          (double prev, next) => prev + ((next.price / 100 * next.vatInPercent) * next.amount),
        )
        .toStringAsFixed(2);
  }
}
