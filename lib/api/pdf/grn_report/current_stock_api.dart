import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/loaded_products.dart';
import 'cs_custome_row.dart';

class LoadItemsAPI {
  static Future<Uint8List> generateGRN(
    List<LoadedProducts> vLoadItems,
    String vehicleNum,
    final String loadedDate,
    final String refName,
  ) async {
    final invoicePDF = pw.Document();
    final List<CSCustomRow> elements = [
      for (var product in vLoadItems) CSCustomRow(product.productsCode, product.productName, product.salePrice.toString(), product.qty.toString()),
    ];
    final image = (await rootBundle.load("assets/flutter_explained_logo.jpg")).buffer.asUint8List();

    invoicePDF.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat(
          21.0 * PdfPageFormat.cm,
          29.7 * PdfPageFormat.cm,
          marginLeft: 1.5 * PdfPageFormat.cm,
          marginBottom: 0.5 * PdfPageFormat.cm,
          marginRight: 0.5 * PdfPageFormat.cm,
          marginTop: 1.0 * PdfPageFormat.cm,
        ),
        header: (context) {
          return pw.Column(children: [
            address(),
            pw.SizedBox(height: 10),
            invoiceNumberInfo(vehicleNum, refName, loadedDate),
            pw.SizedBox(height: 3),
            pw.Divider(height: 7),
            rowHeaders(),
            pw.Divider(height: 7),
          ]);
        },
        footer: (context) {
          return pw.Column(children: [footer()]);
        },
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.center, mainAxisSize: pw.MainAxisSize.min, children: [
              //invoiceLogo(image),
              /*address(),
              pw.SizedBox(height: 10),
              invoiceNumberInfo(vehicleNum, refName),
              pw.SizedBox(height: 3),
              pw.Divider(height: 7),
              rowHeaders(),
              pw.Divider(height: 7),*/
              itemColumn(elements),
              pw.Divider(height: 7, thickness: 0.5),
              //values(0, 0, 0, 0, 'No', 0, 0),
              //pw.Divider(height: 7, thickness: 0.5),
              //footer(),
            ]),
          ];
        },
      ),
    );

    /*invoicePDF.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, mainAxisAlignment: pw.MainAxisAlignment.center, mainAxisSize: pw.MainAxisSize.min, children: [
            //invoiceLogo(image),
            address(),
            pw.SizedBox(height: 5),
            invoiceNumberInfo(vehicleNum),
            pw.SizedBox(height: 3),
            pw.Divider(height: 7),
            rowHeaders(),
            pw.Divider(height: 7),
            itemColumn(elements),
            pw.Divider(height: 7, thickness: 0.5),
            //values(0, 0, 0, 0, 'No', 0, 0),
            //pw.Divider(height: 7, thickness: 0.5),
            //footer(),
          ]);
        },
      ),
    );*/

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
            pw.Text("Good Receiving Note", style: const pw.TextStyle(fontSize: 12)),
            /*pw.Row(children: [
              pw.Text("Pahala Galkandegama, Punewa", style: const pw.TextStyle(fontSize: 11)),
            ]),
            pw.Row(children: [
              pw.Text("0761357747 / 0718106264", style: const pw.TextStyle(fontSize: 11)),
            ])*/
          ],
        ),
      ],
    );
  }

  static pw.Widget invoiceNumberInfo(String vehicleNum, String refName, String loadedDate) {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          pw.Expanded(
              child: pw.Row(children: [
            pw.Text("Vehicle Num : ", style: const pw.TextStyle(fontSize: 10)),
            pw.Text(vehicleNum, style: const pw.TextStyle(fontSize: 10)),
          ])),
          pw.Expanded(
              child: pw.Row(children: [
            pw.Text("Ref Name : ", style: const pw.TextStyle(fontSize: 10)),
            pw.Text(refName, style: const pw.TextStyle(fontSize: 10)),
          ])),
          pw.Row(children: [pw.Text("Date : ", style: const pw.TextStyle(fontSize: 10)), pw.Text(loadedDate, style: const pw.TextStyle(fontSize: 10))]),
          pw.SizedBox(height: 2),
        ],
      ),
    ]);
  }

  static pw.Widget rowHeaders() {
    return pw.Row(children: [
      pw.Expanded(child: pw.Text('Code', textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 10))),
      pw.Expanded(child: pw.Text('Name', textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 10))),
      pw.Expanded(child: pw.Text('Price', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      pw.Expanded(child: pw.Text('Qty', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
    ]);
  }

  static pw.Widget values(int itemCount, double totalAmount, double discountValue, double discountPra, String paymentMethode, double payedAmount, double deuAmount) {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 18),
        pw.Expanded(child: pw.Text('Item Count :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(itemCount.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 18),
        pw.Expanded(child: pw.Text('Total Amount :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(totalAmount.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 18),
        pw.Expanded(child: pw.Text('Dis Value :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(discountValue.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 18),
        pw.Expanded(child: pw.Text('Dis Prec % :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(discountPra.toStringAsFixed(2), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 18),
        pw.Expanded(child: pw.Text('Pay Methode :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(paymentMethode, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 18),
        pw.Expanded(child: pw.Text('Payed Amount :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(payedAmount.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ]),
      pw.SizedBox(height: 2),
      pw.Row(children: [
        pw.SizedBox(width: 18),
        pw.Expanded(child: pw.Text('Deu Amount :', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
        pw.Expanded(child: pw.Text(deuAmount.toString(), textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 10))),
      ])
    ]);
  }

  static pw.Widget footer() {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly, children: [
        pw.Expanded(
            child: pw.Row(children: [
          pw.Text('................................', style: const pw.TextStyle(fontSize: 10)),
        ])),
        pw.Expanded(
            child: pw.Row(children: [
          pw.Text('............................', style: const pw.TextStyle(fontSize: 10)),
        ])),
        pw.Expanded(
            child: pw.Row(children: [
          pw.Text('............................', style: const pw.TextStyle(fontSize: 10)),
        ])),
      ]),
      pw.Row(children: [
        pw.Expanded(
            child: pw.Row(children: [
          pw.Text("  Store Keeper Sign", style: const pw.TextStyle(fontSize: 10)),
        ])),
        pw.Expanded(
            child: pw.Row(children: [
          pw.Text("       Ref Sign", style: const pw.TextStyle(fontSize: 10)),
        ])),
        pw.Expanded(
            child: pw.Row(children: [
          pw.Text("       Diver Sign", style: const pw.TextStyle(fontSize: 10)),
        ])),
      ])
    ]);
  }

  static pw.Widget itemColumn(List<CSCustomRow> elements) {
    return pw.Column(
      children: [
        for (var element in elements)
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
            pw.SizedBox(height: 2),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Expanded(child: pw.Text(element.pCode, textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 8))),
                pw.Expanded(child: pw.Text(element.pName, textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 8))),
                pw.Expanded(child: pw.Text(element.qty, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 8))),
                pw.Expanded(child: pw.Text(element.salePrice, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 8))),
              ],
            ),
            //pw.SizedBox(height: 2),
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
