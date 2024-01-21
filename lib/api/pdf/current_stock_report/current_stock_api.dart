import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import '../../../models/vehicle_stock.dart';
import 'cs_custome_row.dart';

class CurrentStockAPI {
  static Future<Uint8List> generateCustomerInvoice(
    List<VehicleStock> vStockItems,
    String vehicleNum,
  ) async {
    final invoicePDF = pw.Document();
    final List<CSCustomRow> elements = [
      for (var product in vStockItems) CSCustomRow(product.pCode, product.pName, product.salePrice.toString(), product.qty.toString()),
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

    _topHeaderLayout() {
      return new pw.Container(
          // height: 60.0,
          margin: pw.EdgeInsets.only(bottom: 20.0),
          child: pw.Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pw.Container(
                margin: pw.EdgeInsets.only(right: 5.0),
                child: pw.Text(
                  '   ',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Container(
                      child: pw.Text(
                        'Product Code',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Text(
                      'Product Name',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <pw.Widget>[
                    pw.Text(
                      'Sale Price',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <pw.Widget>[
                    pw.Text(
                      'Current Qty',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <pw.Widget>[
                    pw.Text(
                      'Physical Qty',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                    ),
                  ],
                ),
              ),
              pw.Container(
                margin: pw.EdgeInsets.only(left: 5.0),
                child: pw.Text(
                  'Marked',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                ),
              ),
            ],
          ));
    }

    _productLayout(VehicleStock item, int index) {
      return new pw.Container(
        // height: 60.0,
        margin: pw.EdgeInsets.only(bottom: 10.0),
        child: pw.Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pw.Container(
              margin: pw.EdgeInsets.only(right: 5.0),
              child: pw.Text(
                index.toString(),
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Container(
                    child: pw.Text(item.pCode, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Container(
                    child: Text(item.pName, style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 8)),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Text(
                    item.salePrice.toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 8),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Text(
                    item.qty.toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 8),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.Text(
                    '..........',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 8),
                  ),
                ],
              ),
            ),
            pw.Container(
              margin: pw.EdgeInsets.only(left: 5.0),
              child: pw.Text(
                '.........',
                style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 8),
              ),
            ),
          ],
        ),
      );
    }

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
            pw.SizedBox(height: 5),
            invoiceNumberInfo(vehicleNum),
            pw.SizedBox(height: 3),
            pw.Divider(height: 7),
          ]);
        },
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
          _topHeaderLayout(),
          for (int i = 0; i < vStockItems.length; i++) _productLayout(vStockItems[i], i + 1),
        ],
      ),
    );

    /*invoicePDF.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(58 * PdfPageFormat.mm, 1000 * PdfPageFormat.mm),
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
            pw.Text("Current Stock", style: const pw.TextStyle(fontSize: 12)),
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

  static pw.Widget invoiceNumberInfo(String vehicleNum) {
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                  child: pw.Text(
                    'Vehicle Num : ' + vehicleNum,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                  ),
                ),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <pw.Widget>[
                pw.Container(
                  child: pw.Text(
                    'Date : ' + DateFormat.yMd().format(DateTime.now()).toString(),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 2),
        ],
      ),
    ]);
  }

  static pw.Widget rowHeaders() {
    return pw.Row(children: [
      pw.Expanded(child: pw.Text('Code', textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 7))),
      pw.Expanded(child: pw.Text('Name', textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 7))),
      pw.Expanded(child: pw.Text('Price', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 7))),
      pw.Expanded(child: pw.Text('Qty', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 7))),
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
    return pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
      pw.SizedBox(height: 2),
      pw.Text("Thanks for your trust !", style: const pw.TextStyle(fontSize: 13)),
      pw.SizedBox(height: 5),
      pw.Text("Software by Bi Helix(pvt) LTD", style: const pw.TextStyle(fontSize: 9)),
      pw.Text("(0777675093 / 0707675093)", style: const pw.TextStyle(fontSize: 9)),
      pw.SizedBox(height: 2),
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
                pw.Expanded(child: pw.Text(element.pCode, textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 7))),
                pw.Expanded(child: pw.Text(element.pName, textAlign: pw.TextAlign.left, style: const pw.TextStyle(fontSize: 7))),
                pw.Expanded(child: pw.Text(element.qty, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 7))),
                pw.Expanded(child: pw.Text(element.salePrice, textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 7))),
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
