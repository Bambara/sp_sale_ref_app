import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:sp_sale_ref_app/data/login_session.dart';

import '../../data/invoice_data.dart';
import '../../models/invoice_items.dart';
import '../../widgets/drawer_menu_widget.dart';
import '../../widgets/invoiced_product_tile_widget.dart';
import 'invoice_finish_bottom_sheet.dart';
import 'invoice_load_bottom_sheet.dart';

class Invoice extends StatefulWidget {
  const Invoice({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/invoice_screen';
  final VoidCallback openDrawer;

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  late List<InvoiceItems> loadedProduct = [];
  int invoiceNumber = 0;
  double grossAmount = 0, itemCount = 0, lineDiscountAmount = 0, discountPra = 0;
  var customerName, carMake, carMakeModel;
  var setDefaultMake = true, setDefaultMakeModel = true;

  void getSelectedVehicleNum(String data) {
    setState(() {
      customerName = data;
    });
  }

  @override
  void initState() {
    super.initState();
    if (invoiceNumber == 0) {
      _genLastInvoiceId();
    }
  }

  /*Future<Stream<List<Product>>> getProducts() async {
    return await FirebaseFirestore.instance.collection('products').snapshots().map((snapshot) => snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }*/

  Future<int> _genLastInvoiceId() async {
    int invoiceId = 0;
    try {
      var variable =
          await FirebaseFirestore.instance.collection('invoice').where('id', isGreaterThan: 0).where('refName', isEqualTo: LoginSession.refName).orderBy('id').get();
      invoiceId = int.parse(variable.docs.last.data()['id'].toString());
      loadInvoiceNumber(invoiceId);
      //Logger().i('Invoice ID');
      //Logger().i(variable.docs.last.data()['id'].toString());
      //qty = double.parse(variable.data()!['qty'].toString());
    } catch (e) {
      invoiceId = 0;
      loadInvoiceNumber(invoiceId);
    }
    return invoiceId;
  }

  /*void _genLastInvoiceId() {
    var map;
    for (int i = 0; i < 2; ++i) {
      map = FirebaseFirestore.instance
          .collection('invoice')
          .where('id', isGreaterThan: 0)
          .orderBy('id')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Invoices.fromJson(doc.data())).toList());
    }
    //Logger().i(map.length);
    if (map.length == 0) {
      loadInvoiceNumber(0);
    } else {
      map.forEach((element) {
        //Logger().i(element.last.id);
        loadInvoiceNumber(element.last.id);
        // for (var vStock in element) {}
      });
    }
  }*/

  void loadInvoiceNumber(int liNumber) {
    setState(() {
      invoiceNumber = (liNumber + 1);
    });
    Logger().i(invoiceNumber);
  }

  void _addProduct(String pCode, String pName, double salePrice, double discountVal, double qty, double aveQty) {
    if (invoiceNumber == 0) {
      _genLastInvoiceId();
      //_genLastInvoiceId();
    }
    if (invoiceNumber > 0 || invoiceNumber == 0) {
      if (invoiceNumber > InvoiceData.preInvoiceNumber) {
        final loadProduct = InvoiceItems(
            invoiceId: invoiceNumber.toString() + '_' + LoginSession.refName,
            productName: pName,
            productCode: pCode,
            salePrice: salePrice,
            discountVal: discountVal,
            qty: qty,
            aveQty: aveQty);
        setState(() {
          grossAmount += (salePrice * qty);
          itemCount += qty;
          lineDiscountAmount += (discountVal * qty);
          loadedProduct.add(loadProduct);
          Logger().i('Invoice ID');
          Logger().i(loadProduct.invoiceId);
          Fluttertoast.showToast(
              msg: "Item Added !",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        });
      } else {
        _removeAllProduct();
        Fluttertoast.showToast(
            msg: "Item Not Added !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Item Not Added !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  void _openItemSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return InvoiceLoadBottomSheetScreen(
            addProduct: _addProduct,
          );
        });
  }

  void _openFinalSheet(context) {
    int invoiceId = invoiceNumber;
    //invoiceNumber = 0;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return InvoiceFinishBottomSheetScreen(
            removeAllProduct: _removeAllProduct,
            invoiceNumber: invoiceNumber,
            totalAmount: grossAmount,
            discountValue: lineDiscountAmount,
            itemCount: itemCount,
            customerName: customerName,
            allProducts: loadedProduct,
          );
        });
  }

  void _removeProduct(int index) {
    setState(() {
      grossAmount -= (loadedProduct[index].salePrice * loadedProduct[index].qty);
      lineDiscountAmount -= (loadedProduct[index].discountVal * loadedProduct[index].qty);
      itemCount -= loadedProduct[index].qty;
      //Logger().i(totalAmount);
      loadedProduct.removeAt(index);
    });
  }

  void _removeAllProduct() {
    setState(() {
      loadedProduct.clear();
      grossAmount = 0;
      itemCount = 0;
      lineDiscountAmount = 0;
      discountPra = 0;
      invoiceNumber = 0;
      /*if (invoiceNumber == 0) {
        _genLastInvoiceId();
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
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
              /*actions: [
                GestureDetector(
                  onTap: () => _openItemSheet(context),
                  child: const Icon(
                    Icons.table_view,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _openFinalSheet(context),
                  child: const Icon(
                    Icons.add_chart,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 40),
              ],*/
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              floating: true,
              snap: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Invoice',
                    style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 20),
                  ),
                  SizedBox(width: 20),
                  Text(
                    '-',
                    style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 20),
                  ),
                  SizedBox(width: 20),
                  Text(
                    '#$invoiceNumber',
                    style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 20),
                  ),
                ],
              ),
              centerTitle: true,
            )
          ],
          body: Column(
            children: [
              /*DropDownButtonWidget(
                  valveChoose: customerName,
                  items: const ["None", "Cash", "Cheque", "Credit"],
                  label: 'Customer Name',
                  isRequired: true,
                  selectData: getSelectedVehicleNum,
                  widthFactor: 0.9,
                  heightFactor: 0.05),
              const SizedBox(height: 10),*/
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 30, bottom: 5, top: 10),
                    child: Row(
                      children: const [
                        Text(
                          'Customer Name',
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
                      future: FirebaseFirestore.instance.collection('customers').where('refName', isEqualTo: LoginSession.refName).get(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        // Safety check to ensure that snapshot contains data
                        // without this safety check, StreamBuilder dirty state warnings will be thrown
                        if (!snapshot.hasData) return Container();
                        // Set this value for default,
                        // setDefault will change if an item was selected
                        // First item from the List will be displayed
                        if (setDefaultMake) {
                          customerName = snapshot.data?.docs[0].get('bussines_name');
                          debugPrint('setDefault make: $customerName');
                        }
                        return DropdownButton(
                          autofocus: true,
                          enableFeedback: true,
                          isExpanded: true,
                          value: customerName,
                          items: snapshot.data?.docs.map((value) {
                            return DropdownMenuItem(
                              value: value.get('bussines_name'),
                              child: Text('${value.get('bussines_name')}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            debugPrint('selected onchange: $value');
                            setState(
                              () {
                                //customerName = value.toString();
                                debugPrint('make selected: $value');
                                // Selected value will be stored
                                customerName = value;
                                // Default dropdown value won't be displayed anymore
                                setDefaultMake = false;
                                // Set makeModel to true to display first car from list
                                setDefaultMakeModel = true;
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
                child: ListView.builder(
                  addAutomaticKeepAlives: false,
                  cacheExtent: 100,
                  itemCount: loadedProduct.length,
                  itemBuilder: (context, index) {
                    return InvoicedProductTileWidget(
                      product: loadedProduct,
                      index: index,
                      funDelete: _removeProduct,
                    );
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
            SpeedDialChild(child: const Icon(FontAwesomeIcons.boxes), label: 'Item List', onTap: () => _openItemSheet(context)),
            SpeedDialChild(child: const Icon(FontAwesomeIcons.moneyBill), label: 'Pay Invoice', onTap: () => _openFinalSheet(context)),
            SpeedDialChild(
                child: const Icon(FontAwesomeIcons.arrowsRotate),
                label: 'Refresh',
                onTap: () {
                  _removeAllProduct();
                  if (invoiceNumber == 0) {
                    _genLastInvoiceId();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
