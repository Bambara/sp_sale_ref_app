import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../models/vehicle_stock.dart';
import 'current_stock_admin_api.dart';

class CurrentStockAdminView extends StatefulWidget {
  const CurrentStockAdminView({Key? key, required this.vStockItems, required this.vehicleNum}) : super(key: key);
  static const routeName = '/current_stock_view';
  final List<VehicleStock> vStockItems;
  final String vehicleNum;

  @override
  State<CurrentStockAdminView> createState() => _CurrentStockAdminViewState();
}

class _CurrentStockAdminViewState extends State<CurrentStockAdminView> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments as CurrentStockAdminView;
    return Scaffold(
      body: buildPdfPreview(arguments),
    );
  }

  PdfPreview buildPdfPreview(CurrentStockAdminView arguments) {
    var view;

    try {
      view = PdfPreview(
        // pageFormats: const {'roll 58mm': PdfPageFormat(58 * PdfPageFormat.mm, 80 * PdfPageFormat.mm)},
        pageFormats: const {'Roll 57mm': PdfPageFormat(58 * PdfPageFormat.mm, 1000 * PdfPageFormat.mm)},
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
