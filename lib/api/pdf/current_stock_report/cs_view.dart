import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../models/vehicle_stock.dart';
import 'current_stock_api.dart';

class CurrentStockView extends StatefulWidget {
  const CurrentStockView({Key? key, required this.vStockItems, required this.vehicleNum}) : super(key: key);
  static const routeName = '/current_stock_view';
  final List<VehicleStock> vStockItems;
  final String vehicleNum;

  @override
  State<CurrentStockView> createState() => _CurrentStockViewState();
}

class _CurrentStockViewState extends State<CurrentStockView> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments as CurrentStockView;
    return Scaffold(
      body: buildPdfPreview(arguments),
    );
  }

  PdfPreview buildPdfPreview(CurrentStockView arguments) {
    var view;

    try {
      view = PdfPreview(
        // pageFormats: const {'roll 58mm': PdfPageFormat(58 * PdfPageFormat.mm, 80 * PdfPageFormat.mm)},
        // pageFormats: const {'Roll 57mm': PdfPageFormat(58 * PdfPageFormat.mm, 1000 * PdfPageFormat.mm)},
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
          return CurrentStockAPI.generateCustomerInvoice(
            arguments.vStockItems,
            arguments.vehicleNum,
          );
        },
      );

      Logger().i(arguments.vStockItems.last.pCode);
    } catch (e) {
      Logger().i(e.toString());
    }
    return view;
  }
}
