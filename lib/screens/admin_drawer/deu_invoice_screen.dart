import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sp_sale_ref_app/models/invoice_deu.dart';
import 'package:sp_sale_ref_app/widgets/deu_invoice_tile_widget.dart';

import '../../api/pdf/deu_summary_admin/deu_summary_admin_view.dart';
import '../../widgets/date_picker_widget.dart';
import '../../widgets/drawer_menu_widget.dart';
import '../sale_ref_drawer/deu_pay_screen.dart';
import 'invoice_summary_items_bottom_screen_admin.dart';

class DeuInvoiceScreenAdmin extends StatefulWidget {
  const DeuInvoiceScreenAdmin({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/deu_invoice_screen';
  final VoidCallback openDrawer;

  @override
  State<DeuInvoiceScreenAdmin> createState() => _DeuInvoiceScreenAdminState();
}

class _DeuInvoiceScreenAdminState extends State<DeuInvoiceScreenAdmin> {
  var customerName, refName;
  var setDefaultMakeCustomer = true, setDefaultMakeModelCustomer = true;
  var setDefaultMakeRef = true, setDefaultMakeModelRef = true;
  late List<InvoiceDeu> allDeuInvoices;
  var selectedDate = DateFormat.yMd().format(DateTime.now()).toString();
  bool dpEnable = false;

  get vehicleNumber => null;

  Future<List<InvoiceDeu>> getDeuInvoice() async {
    if (dpEnable == true) {
      return await FirebaseFirestore.instance
          .collection('deu_invoice')
          .orderBy('invoiceNumber')
          .where('date', isEqualTo: selectedDate)
          .where('refName', isEqualTo: refName)
          .get()
          .then((value) => value.docs.map((e) => InvoiceDeu.fromJson(e.data())).toList());
      /*.snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => InvoiceDeu.fromJson(doc.data())).toList());*/
    } else {
      return await FirebaseFirestore.instance
          .collection('deu_invoice')
          //.where('deuAmount', isGreaterThan: 0)
          //.where('invoiceNumber', isGreaterThanOrEqualTo: 0)
          .orderBy('invoiceNumber')
          .where('refName', isEqualTo: refName)
          .get()
          .then((value) => value.docs.map((e) => InvoiceDeu.fromJson(e.data())).toList());
      //.where('customerName', isEqualTo: customerName)
      // .where('date', isEqualTo: DateFormat.yMd().format(DateTime.now()).toString())
      //.where('invoiceNumber', isNotEqualTo: 0)
      /*.snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => InvoiceDeu.fromJson(doc.data())).toList());*/

    }
  }

  void searchProductByCusName(String query) {
    final suggestions = allDeuInvoices.where((product) {
      final cusName = product.customerName.toLowerCase();
      final input = query.toLowerCase();

      return cusName.startsWith(input);
    }).toList();

    setState(() {
      allDeuInvoices = suggestions;
    });
  }

  void searchDeuInvoiceByAmount(double deuAmount) {
    final suggestions = allDeuInvoices.where((invoice) {
      final deu = invoice.deuAmount;

      return deu != deuAmount;
    }).toList();

    setState(() {
      allDeuInvoices = suggestions;
    });
  }

  void _openFinalSheet(context, String invoiceId, String customerName, double deuAmount) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return InvoiceDeuPayBottomSheet(invoiceId: invoiceId, customerName: customerName, deuAmount: deuAmount);
        });
  }

  void _getSelectedDate(String date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _openItemSheet(context, invoiceId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return InvoiceSummaryItemsBottomSheetAdmin(invoiceId: invoiceId, refName: refName);
        });
  }

  void _openDeuSummaryReport() {
    searchDeuInvoiceByAmount(0);
    Navigator.of(context).pushNamed(
      DeuSummaryAdminView.routeName,
      arguments: DeuSummaryAdminView(
        allInvoices: allDeuInvoices,
        refName: refName,
        date: selectedDate,
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
              'Due Invoice',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DatePickerWidget(label: 'Date', isRequired: true, widthFactor: 0.8, heightFactor: 0.05, selectedDate: _getSelectedDate, pickedDate: selectedDate),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Checkbox(
                            value: dpEnable,
                            onChanged: (value) {
                              setState(() {
                                this.dpEnable = value!;
                              });
                            })),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 30, bottom: 5, top: 10),
                  child: Row(
                    children: const [
                      Text(
                        'Ref Name',
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
                    future: FirebaseFirestore.instance.collection('users').get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      // Safety check to ensure that snapshot contains data
                      // without this safety check, StreamBuilder dirty state warnings will be thrown
                      if (!snapshot.hasData) return Container();
                      // Set this value for default,
                      // setDefault will change if an item was selected
                      // First item from the List will be displayed
                      if (setDefaultMakeRef) {
                        refName = snapshot.data?.docs[0].get('user_name');
                        debugPrint('setDefault make: $refName');
                      }
                      return DropdownButton(
                        autofocus: true,
                        enableFeedback: true,
                        isExpanded: true,
                        value: refName,
                        items: snapshot.data?.docs.map((value) {
                          return DropdownMenuItem(
                            value: value.get('user_name'),
                            child: Text('${value.get('user_name')}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          //debugPrint('selected onchange: $value');
                          //getInvoices();
                          //calDailyIncome();
                          setState(
                            () {
                              //calDailyIncome();
                              //customerName = value.toString();
                              //debugPrint('make selected: $value');
                              // Selected value will be stored
                              refName = value;
                              // Default dropdown value won't be displayed anymore
                              setDefaultMakeRef = false;
                              // Set makeModel to true to display first car from list
                              setDefaultMakeModelRef = true;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
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
                    future: FirebaseFirestore.instance.collection('customers').where('refName', isEqualTo: refName).get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      // Safety check to ensure that snapshot contains data
                      // without this safety check, StreamBuilder dirty state warnings will be thrown
                      if (!snapshot.hasData) return Container();
                      // Set this value for default,
                      // setDefault will change if an item was selected
                      // First item from the List will be displayed
                      if (setDefaultMakeCustomer) {
                        customerName = snapshot.data?.docs[0].get('bussines_name');
                        //debugPrint('setDefault make: $customerName');
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
                          //debugPrint('selected onchange: $value');
                          setState(
                            () {
                              //customerName = value.toString();
                              //debugPrint('make selected: $value');
                              // Selected value will be stored
                              customerName = value;
                              // Default dropdown value won't be displayed anymore
                              setDefaultMakeCustomer = false;
                              // Set makeModel to true to display first car from list
                              setDefaultMakeModelCustomer = true;
                              searchProductByCusName(value.toString());
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
                      itemCount: allDeuInvoices.length,
                      itemBuilder: (context, index) {
                        allDeuInvoices.sort((a, b) => a.invoiceNumber.compareTo(b.invoiceNumber));

                        return DeuInvoiceTileWidget(
                          deuInvoices: allDeuInvoices.toList(),
                          index: index,
                          // addProduct: widget.addProduct(allProducts.toList()[index].productName, allProducts.toList()[index].productName, 0, 0),
                          viewItemSheet: _openItemSheet,
                          viewPaySheet: _openFinalSheet,
                        );
                      },
                    )
                  : FutureBuilder<List<InvoiceDeu>>(
                      future: getDeuInvoice(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Oops!! Something went wrong!!'));
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('Oops!! No Any Data Found!!'));
                        } else if (snapshot.hasData) {
                          allDeuInvoices = snapshot.data!;

                          allDeuInvoices.sort((a, b) => a.invoiceNumber.compareTo(b.invoiceNumber));

                          return ListView.builder(
                            addAutomaticKeepAlives: false,
                            cacheExtent: 100,
                            itemCount: allDeuInvoices.length,
                            itemBuilder: (context, index) {
                              return DeuInvoiceTileWidget(
                                deuInvoices: allDeuInvoices.toList(),
                                index: index,
                                // addProduct: widget.addProduct(allProducts.toList()[index].productName, allProducts.toList()[index].productName, 0, 0),
                                viewItemSheet: _openItemSheet,
                                viewPaySheet: _openFinalSheet,
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
          //SpeedDialChild(child: const Icon(FontAwesomeIcons.boxes), label: 'Current Stock', onTap: _openCurrentStockReport),
          SpeedDialChild(child: const Icon(FontAwesomeIcons.receipt), label: 'Daily GRN Report', onTap: () => _openDeuSummaryReport()),
        ],
      ),
    );
  }
}
