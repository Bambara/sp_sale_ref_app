import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sp_sale_ref_app/models/vehicle_stock.dart';
import 'package:sp_sale_ref_app/widgets/vehicle_stock_product_tile_widget.dart';

import '../../api/pdf/current_stock_report/cs_view.dart';
import '../../widgets/drawer_menu_widget.dart';
import 'grn_bottom_screen.dart';
import 'item_stock_update_bottom_screen.dart';

class VehicleStockScreenAdmin extends StatefulWidget {
  const VehicleStockScreenAdmin({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/deu_invoice_screen';
  final VoidCallback openDrawer;

  @override
  State<VehicleStockScreenAdmin> createState() => _VehicleStockScreenAdminState();
}

class _VehicleStockScreenAdminState extends State<VehicleStockScreenAdmin> {
  var vehicleNumber;
  var setDefaultMakeVehicle = true, setDefaultMakeModelVehicle = true;
  late List<VehicleStock> allProducts;

  Future<List<VehicleStock>> _getVehicleStock() async {
    return await FirebaseFirestore.instance
        .collection('vehicle_stock')
        .where('vehicleNum', isEqualTo: vehicleNumber)
        // .where('qty', isGreaterThan: 0)
        .get()
        .then((value) => value.docs.map((e) => VehicleStock.fromJson(e.data())).toList());
    //.where('pName', isNotEqualTo: '0')
    //.orderBy('pName')
    //.orderBy('qty')
    // .where('date', isEqualTo: DateFormat.yMd().format(DateTime.now()).toString())
    /*.snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => VehicleStock.fromJson(doc.data())).toList());*/
  }

  /*void searchProductByCusName(String query) {
    final suggestions = allProducts.where((product) {
      final cusName = product.customerName.toLowerCase();
      final input = query.toLowerCase();

      return cusName.startsWith(input);
    }).toList();

    setState(() {
      allProducts = suggestions;
    });
  }*/

  void _openFinalSheet(context, VehicleStock vehicleStock) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return ItemStockUpdateBottomSheet(vehicleStock: vehicleStock);
        });
  }

  void _openGRNSheet(context, String vehicleNumber) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return GrnBottomSheet(vehicleNumber: vehicleNumber);
        });
  }

  void _openCurrentStockReport() {
    allProducts.sort((a, b) => a.pName.compareTo(b.pName));

    Navigator.of(context).pushNamed(
      CurrentStockView.routeName,
      arguments: CurrentStockView(
        vStockItems: allProducts,
        vehicleNum: vehicleNumber,
      ),
    );
  }

  Widget _getButton() {
    return Container(
      width: 131,
      height: 50,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                        color: Color.fromRGBO(1, 67, 236, 1),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(),
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(width: 8),
                                Text(
                                  'Label',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5 /*PERCENT not supported*/
                                      ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
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
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 30, bottom: 5, top: 10),
                  child: Row(
                    children: const [
                      Text(
                        'Vehicle Number',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      SizedBox(width: 2),
                      true
                          ? Text(
                              "*",
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            )
                          : Text(""),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black54, width: 0.5),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('vehicles').get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      // Safety check to ensure that snapshot contains data
                      // without this safety check, StreamBuilder dirty state warnings will be thrown
                      if (!snapshot.hasData) return Container();
                      // Set this value for default,
                      // setDefault will change if an item was selected
                      // First item from the List will be displayed
                      if (setDefaultMakeVehicle) {
                        vehicleNumber = snapshot.data?.docs[0].get('vehicleNumber');
                        //debugPrint('setDefault make: $customerName');
                      }
                      return DropdownButton(
                        autofocus: true,
                        enableFeedback: true,
                        isExpanded: true,
                        value: vehicleNumber,
                        items: snapshot.data?.docs.map((value) {
                          return DropdownMenuItem(
                            value: value.get('vehicleNumber'),
                            child: Text('${value.get('vehicleNumber')}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          //debugPrint('selected onchange: $value');
                          setState(
                            () {
                              //customerName = value.toString();
                              //debugPrint('make selected: $value');
                              // Selected value will be stored
                              vehicleNumber = value;
                              // Default dropdown value won't be displayed anymore
                              setDefaultMakeVehicle = false;
                              // Set makeModel to true to display first car from list
                              setDefaultMakeModelVehicle = true;
                              //searchProductByCusName(value.toString());
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
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
                          viewUpdateSheet: _openFinalSheet,
                        );
                      },
                    )
                  : FutureBuilder<List<VehicleStock>>(
                      future: _getVehicleStock(),
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
                                viewUpdateSheet: _openFinalSheet,
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
          SpeedDialChild(child: const Icon(FontAwesomeIcons.receipt), label: 'Daily GRN Report', onTap: () => _openGRNSheet(context, vehicleNumber)),
        ],
      ),
    );
  }
}
