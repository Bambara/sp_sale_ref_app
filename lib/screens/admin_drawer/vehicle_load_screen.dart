import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../data/login_session.dart';
import '../../models/loaded_products.dart';
import '../../models/vehicle_load.dart';
import '../../models/vehicle_stock.dart';
import '../../widgets/drawer_menu_widget.dart';
import '../../widgets/dropdown_button_widget.dart';
import '../../widgets/loaded_product_tile_widget.dart';
import 'vehicle_load_bottom_sheet.dart';

class VehicleLoadScreen extends StatefulWidget {
  const VehicleLoadScreen({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/customer_reg';
  final VoidCallback openDrawer;

  @override
  State<VehicleLoadScreen> createState() => _VehicleLoadScreenState();
}

class _VehicleLoadScreenState extends State<VehicleLoadScreen> {
  /*Stream<List<Product>> getCustomers() =>
      FirebaseFirestore.instance.collection('products').snapshots().map((snapshot) => snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());*/

  String vehicleNumber = 'None';
  String refName = 'None';
  late List<LoadedProducts> loadedProduct = [];
  String loadId = '';
  bool load = false;

  // double preQty = 0;

  void getSelectedVehicleNum(String data) {
    setState(() {
      vehicleNumber = data;
    });
  }

  void getSelectedRefName(String data) {
    setState(() {
      refName = data;
    });
  }

  void _loadNow() async {
    var dialogContext;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 20,
                height: 170,
                child: Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Please Wait ! Stock Updating.....'),
                  ],
                ),
              ));
        });
    _loadVehicle().whenComplete(
      () => _loadVehicleItems().whenComplete(
        () => _loadVehicleStock().whenComplete(
          () {
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  Future<void> _loadVehicle() async {
    final vehicleLoad = VehicleLoad(id: loadId, vehicleNumber: vehicleNumber, loadDate: DateFormat.yMd().format(DateTime.now()).toString(), refName: vehicleNumber);
    final vehicleLoadDoc = FirebaseFirestore.instance.collection('vehicle_load').doc(loadId);

    await vehicleLoadDoc.set(vehicleLoad.toJson());
    // _loadVehicleItems();
  }

  Future<void> _loadVehicleItems() async {
    var batch = FirebaseFirestore.instance.batch();

    String loadId = '';
    String date = DateFormat.yMd().format(DateTime.now()).toString();
    String time = DateFormat.Hm().format(DateTime.now()).toString();
    date = date.replaceAll('/', '-');
    loadId = vehicleNumber + '_' + refName + '_' + date + '_' + time;

    for (var loadedP in loadedProduct) {
      String stockId = loadId + '_' + loadedP.productsCode + '_' + loadedP.salePrice.toString();
      final loadedItemsDoc = FirebaseFirestore.instance.collection('vehicle_loaded_items').doc(stockId);
      batch.set(loadedItemsDoc, loadedP.toJson());
    }
    await batch.commit();
    // _loadVehicleStock();
  }

  Future<double> _getVal(String vehicleNumber, String productsCode, double salePrice) async {
    double qty = 0;
    try {
      var variable = await FirebaseFirestore.instance.collection('vehicle_stock').doc(vehicleNumber + '_' + productsCode + '_' + salePrice.toString()).get();
      qty = double.parse(variable.data()!['qty'].toString());
    } catch (e) {
      qty = 0;
    }
    return qty;
  }

  Future<void> _loadVehicleStock() async {
    List<VehicleStock> vehicleStock = [];
    double preQty = 0;
    //var batch = FirebaseFirestore.instance.batch();

    for (var loadedP in loadedProduct) {
      _getVal(vehicleNumber, loadedP.productsCode, loadedP.salePrice).then((value) async {
        preQty = value;
        if (preQty > 0) {
          String stockId = vehicleNumber + '_' + loadedP.productsCode + '_' + loadedP.salePrice.toString();

          var newQty = (loadedP.qty + preQty);

          final updateItemsDoc = FirebaseFirestore.instance.collection('vehicle_stock').doc(stockId);

          await updateItemsDoc.update({'qty': newQty});
        } else if (preQty == 0) {
          debugPrint('Save Qty 1 : ' + preQty.toString());

          String stockId = vehicleNumber + '_' + loadedP.productsCode + '_' + loadedP.salePrice.toString();

          final vehicleStockDoc = FirebaseFirestore.instance.collection('vehicle_stock').doc(stockId);

          final vehicleStock = VehicleStock(
              stockId: stockId,
              vehicleNum: vehicleNumber,
              pCode: loadedP.productsCode,
              pName: loadedP.productName,
              pImage: loadedP.productImage,
              salePrice: loadedP.salePrice,
              qty: loadedP.qty);

          await vehicleStockDoc.set(vehicleStock.toJson());
        }
      });
    }
    _removeAllProduct();
  }

  void _genLoadId() {
    String date = DateFormat.yMd().format(DateTime.now()).toString();
    date = date.replaceAll('/', '-');
    loadId = vehicleNumber + '_' + refName + '_' + date;
  }

  void _addProduct(String pCode, String pName, String pImage, double salePrice, double qty) {
    _genLoadId();
    final loadProduct = LoadedProducts(loadId: loadId, productName: pName, productsCode: pCode, productImage: pImage, salePrice: salePrice, qty: qty);
    setState(() {
      loadedProduct.add(loadProduct);
      Fluttertoast.showToast(
          msg: "Item Added !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void _removeProduct(int index) {
    setState(() {
      loadedProduct.removeAt(index);
    });
  }

  void _removeAllProduct() {
    setState(() {
      loadedProduct.clear();
      loadId = '';
    });
  }

  void _openItemSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return VehicleLoadBottomSheetScreen(
            addProduct: _addProduct,
          );
        });
  }

  Future<List<VehicleStock>> getProducts() async {
    return await FirebaseFirestore.instance
        .collection('vehicle_stock')
        .where('stockId', isEqualTo: 'None_AP0120CB_20.0')
        .get()
        .then((value) => value.docs.map((e) => VehicleStock.fromJson(e.data())).toList());
    /*.snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => VehicleStock.fromJson(doc.data())).toList());*/
  }

  late List<VehicleStock> allProducts;

  @override
  Widget build(BuildContext context) {
    //preQty = 0;
    return SafeArea(
      child: Scaffold(
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
                'Vehicle Load',
                style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 20),
              ),
              centerTitle: true,
            )
          ],
          body: Column(
            children: [
              DropDownButtonWidget(
                  valveChoose: vehicleNumber,
                  items: LoginSession.vnList,
                  label: 'Vehicle Number',
                  isRequired: true,
                  selectData: getSelectedVehicleNum,
                  widthFactor: 0.9,
                  heightFactor: 0.05),
              const SizedBox(height: 10),
              DropDownButtonWidget(
                  valveChoose: refName,
                  items: LoginSession.refList,
                  label: 'Ref Name',
                  isRequired: true,
                  selectData: getSelectedRefName,
                  widthFactor: 0.9,
                  heightFactor: 0.05),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  addAutomaticKeepAlives: false,
                  cacheExtent: 100,
                  itemCount: loadedProduct.length,
                  itemBuilder: (context, index) {
                    return LoadedProductTileWidget(
                      product: loadedProduct,
                      index: index,
                      addProduct: _addProduct,
                      funDelete: _removeProduct,
                    );
                  },
                ),
                // child: StreamBuilder<List<VehicleStock>>(
                //   stream: getProducts(),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasError) {
                //       return const Center(child: Text('No Products Found'));
                //     } else if (snapshot.hasData) {
                //       allProducts = snapshot.data!;
                //
                //       return ListView.builder(
                //         addAutomaticKeepAlives: false,
                //         cacheExtent: 100,
                //         itemCount: allProducts.length,
                //         itemBuilder: (context, index) {
                //           debugPrint('Pre Qty 2 : ' + allProducts[index].stockId);
                //           return Text(allProducts[index].stockId);
                //         },
                //       );
                //     } else {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //   },
                // ),
              ),
            ],
          ),
        ),
        /*floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            _loadNow();
          },
          child: Image.asset('assets/icons/done.png', width: 48, height: 48),
        ),*/
        floatingActionButton: SpeedDial(
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          animatedIcon: AnimatedIcons.menu_close,
          spacing: 10,
          children: [
            SpeedDialChild(child: const Icon(FontAwesomeIcons.listCheck), label: 'Item List', onTap: () => _openItemSheet(context)),
            SpeedDialChild(
                child: const Icon(Icons.done_all),
                label: 'Load Now',
                onTap: () {
                  _loadNow();
                }),
          ],
        ),
      ),
    );
  }
}
