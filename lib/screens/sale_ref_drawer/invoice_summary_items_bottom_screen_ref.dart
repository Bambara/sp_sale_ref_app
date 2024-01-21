import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sp_sale_ref_app/data/login_session.dart';
import 'package:sp_sale_ref_app/models/invoice_items.dart';

import '../../api/pdf/invoice_view/pre_invoice_view.dart';
import '../../models/invoices.dart';
import '../../widgets/image_button_widget.dart';
import '../../widgets/invoice_summary_product_tile_widget.dart';

class InvoiceSummaryItemsBottomSheetRef extends StatefulWidget {
  const InvoiceSummaryItemsBottomSheetRef({Key? key, required this.invoiceId}) : super(key: key);
  final String invoiceId;

  @override
  _InvoiceSummaryItemsBottomSheetRefState createState() => _InvoiceSummaryItemsBottomSheetRefState();
}

class _InvoiceSummaryItemsBottomSheetRefState extends State<InvoiceSummaryItemsBottomSheetRef> {
  late List<InvoiceItems> allProducts;
  late Invoices invoices;

  @override
  void initState() {
    super.initState();
    _getInvoiceById(int.parse(widget.invoiceId.toString()));
  }

  Future<List<InvoiceItems>> getProducts() async {
    return await FirebaseFirestore.instance
        .collection('invoice_items')
        .where('invoiceId', isEqualTo: widget.invoiceId + '_' + LoginSession.refName)
        .get()
        .then((value) => value.docs.map((e) => InvoiceItems.fromJson(e.data())).toList());
    /*.snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => InvoiceItems.fromJson(doc.data())).toList());*/
  }

  Future<void> _getInvoiceById(int invoiceNumber) async {
    try {
      var variable = await FirebaseFirestore.instance.collection('invoice').where('id', isEqualTo: invoiceNumber).where('refName', isEqualTo: LoginSession.refName).get();

      setState(() {
        invoices = Invoices(
          id: variable.docs.last.data()['id'],
          date: variable.docs.last.data()['date'],
          customerName: variable.docs.last.data()['customerName'],
          refName: variable.docs.last.data()['refName'],
          vehicleNum: variable.docs.last.data()['vehicleNum'],
          itemCount: variable.docs.last.data()['itemCount'],
          totalAmount: variable.docs.last.data()['totalAmount'],
          disValue: variable.docs.last.data()['disValue'],
          disPrace: variable.docs.last.data()['disPrace'],
          netAmount: variable.docs.last.data()['netAmount'],
          pMethode: variable.docs.last.data()['pMethode'],
          pAmount: variable.docs.last.data()['pAmount'],
          deuAmount: variable.docs.last.data()['deuAmount'],
        );
      });

      // Logger().i('Invoice ID');
      // Logger().i(invoices.refName);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _openInvoiceView() {
    Navigator.of(context).pushNamed(
      PreInvoiceView.routeName,
      arguments: PreInvoiceView(
        allProducts: allProducts,
        invoiceNumber: invoices.id,
        invoiceDate: invoices.date,
        customerName: invoices.customerName,
        refName: invoices.refName,
        itemCount: invoices.itemCount,
        totalAmount: invoices.totalAmount,
        deuAmount: invoices.deuAmount,
        discountPra: invoices.disPrace,
        discountValue: invoices.disValue,
        netAmount: invoices.netAmount,
        payedAmount: invoices.pAmount,
        paymentMethode: invoices.pMethode,
      ),
    );
    Logger().i('Ok');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Call Invoice ID : ' + widget.invoiceId);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Center(child: Text('Product List', style: TextStyle(fontSize: 20))),
                ),
                IconButtonWidget(imagePath: '', function: _openInvoiceView, iconData: Icons.print, isIcon: true, iconSize: 32, color: Colors.black),
                SizedBox(width: 20),
                IconButtonWidget(
                    imagePath: '',
                    function: () {
                      Navigator.of(context).pop();
                    },
                    iconData: Icons.close,
                    isIcon: true,
                    iconSize: 32,
                    color: Colors.black)
              ],
            ),
            Expanded(
              child: FutureBuilder<List<InvoiceItems>>(
                future: getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('No Products Found'));
                  } else if (snapshot.hasData) {
                    allProducts = snapshot.data!;

                    return ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: allProducts.length,
                      itemBuilder: (context, index) {
                        return InvoiceSummaryProductTileWidget(
                          product: allProducts.toList(),
                          index: index,
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
