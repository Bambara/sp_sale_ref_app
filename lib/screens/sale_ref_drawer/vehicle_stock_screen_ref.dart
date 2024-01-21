import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sp_sale_ref_app/data/login_session.dart';
import 'package:sp_sale_ref_app/models/vehicle_stock.dart';
import 'package:sp_sale_ref_app/widgets/vehicle_stock_product_tile_widget.dart';

import '../../api/pdf/current_stock_report/cs_view.dart';
import '../../models/vehicle_load.dart';
import '../../widgets/drawer_menu_widget.dart';
import '../admin_drawer/invoice_summary_items_bottom_screen_admin.dart';

class VehicleStockScreenRef extends StatefulWidget {
  const VehicleStockScreenRef({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/deu_invoice_screen';
  final VoidCallback openDrawer;

  @override
  State<VehicleStockScreenRef> createState() => _VehicleStockScreenRefState();
}

class _VehicleStockScreenRefState extends State<VehicleStockScreenRef> {
  var vehicleNumber;
  var setDefaultMakeVehicle = true, setDefaultMakeModelVehicle = true;
  late List<VehicleStock> allProducts;
  late VehicleLoad vehicleLoad;

  Future<List<VehicleStock>> _getDeuInvoice() async {
    return await FirebaseFirestore.instance
        .collection('vehicle_stock')
        .where('vehicleNum', isEqualTo: LoginSession.vehicleNum)
        .where('qty', isGreaterThan: 0)
        // .where('date', isEqualTo: DateFormat.yMd().format(DateTime.now()).toString())
        /*.snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => VehicleStock.fromJson(doc.data())).toList());*/
        .get()
        .then((value) => value.docs.map((e) => VehicleStock.fromJson(e.data())).toList());
  }

  void _openCurrentStockReport() {
    allProducts.sort((a, b) => a.pName.compareTo(b.pName));

    Navigator.of(context).pushNamed(
      CurrentStockView.routeName,
      arguments: CurrentStockView(
        vStockItems: allProducts,
        vehicleNum: LoginSession.vehicleNum,
      ),
    );
  }

  Future<void> _getInvoiceById(String vehicleNumber, String refName, String date) async {
    try {
      var variable = await FirebaseFirestore.instance.collection('vehicle_load').where('id', isEqualTo: vehicleNumber + '_' + refName + '_' + date).get();

      setState(() {
        vehicleLoad = VehicleLoad(
          id: variable.docs.last.data()['id'],
          loadDate: variable.docs.last.data()['loadDate'],
          refName: variable.docs.last.data()['refName'],
          vehicleNumber: variable.docs.last.data()['vehicleNumber'],
        );
      });

      // Logger().i('Invoice ID');
      // Logger().i(invoices.refName);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _openItemSheet(context, invoiceId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return InvoiceSummaryItemsBottomSheetAdmin(invoiceId: invoiceId, refName: LoginSession.refName);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            leading: DrawerMenuWidget(
              onClicked: widget.openDrawer,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            floating: true,
            snap: true,
            title: const Text(
              'Vehicle Stock',
              style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 20),
            ),
            centerTitle: true,
          )
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: '' != '' || '' != ''
                  ? ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: allProducts.length,
                      itemBuilder: (context, index) {
                        allProducts.sort((a, b) => a.pName.compareTo(b.pName));

                        return VehicleStockProductTileWidget(
                          product: allProducts.toList(),
                          index: index,
                          viewUpdateSheet: (BuildContext context, VehicleStock vehicleStock) {},
                        );
                      },
                    )
                  : FutureBuilder<List<VehicleStock>>(
                      future: _getDeuInvoice(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('No Products Found'));
                        } else if (snapshot.hasData) {
                          allProducts = snapshot.data!;

                          allProducts.sort((a, b) => a.pName.compareTo(b.pName));

                          return ListView.builder(
                            addAutomaticKeepAlives: false,
                            cacheExtent: 100,
                            itemCount: allProducts.length,
                            itemBuilder: (context, index) {
                              return VehicleStockProductTileWidget(
                                product: allProducts.toList(),
                                index: index,
                                viewUpdateSheet: (BuildContext context, VehicleStock vehicleStock) {},
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
      floatingActionButton: SpeedDial(
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10,
        children: [
          SpeedDialChild(child: const Icon(FontAwesomeIcons.boxes), label: 'Current Stock', onTap: _openCurrentStockReport),
          SpeedDialChild(child: const Icon(FontAwesomeIcons.receipt), label: 'Daily GRN Report'),
        ],
      ),
    );
  }
}
