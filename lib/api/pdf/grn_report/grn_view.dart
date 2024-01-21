import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../models/loaded_products.dart';
import 'current_stock_api.dart';

class GRNView extends StatefulWidget {
  const GRNView({Key? key, required this.vGrnItems, required this.vehicleNum, required this.loadedDate, required this.refName}) : super(key: key);
  static const routeName = '/grn_view';
  final List<LoadedProducts> vGrnItems;
  final String vehicleNum;
  final String loadedDate;
  final String refName;

  @override
  State<GRNView> createState() => _GRNViewState();
}

class _GRNViewState extends State<GRNView> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments as GRNView;
    return Scaffold(
      body: buildPdfPreview(arguments),
    );
  }

  PdfPreview buildPdfPreview(GRNView arguments) {
    var view;

    try {
      view = PdfPreview(
        // pageFormats: const {'roll 58mm': PdfPageFormat(58 * PdfPageFormat.mm, 80 * PdfPageFormat.mm)},
        pageFormats: const {'A4': PdfPageFormat.a4},
        build: (pageFormat) async {
          return LoadItemsAPI.generateGRN(arguments.vGrnItems, arguments.vehicleNum, arguments.loadedDate, arguments.refName);
        },
      );

      Logger().i(arguments.vGrnItems.last.productsCode);
    } catch (e) {
      Logger().i(e.toString());
    }
    return view;
  }
}
