import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sp_sale_ref_app/api/pdf/invoices_summary_ref/invoice_summary_ref_view.dart';

import '../../data/login_session.dart';
import '../../models/invoices.dart';
import '../../widgets/date_picker_widget.dart';
import '../../widgets/drawer_menu_widget.dart';
import '../../widgets/invoice_summary_app_bar.dart';
import '../../widgets/invoice_tile_widget.dart';
import 'invoice_summary_items_bottom_screen_ref.dart';

class InvoiceSummaryScreenRef extends StatefulWidget {
  const InvoiceSummaryScreenRef({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/invoice_summary_screen';
  final VoidCallback openDrawer;

  @override
  State<InvoiceSummaryScreenRef> createState() => _InvoiceSummaryScreenRefState();
}

class _InvoiceSummaryScreenRefState extends State<InvoiceSummaryScreenRef> {
  late List<Invoices> allInvoices;
  var customerName, carMake, carMakeModel;
  var setDefaultMake = true, setDefaultMakeModel = true;
  var selectedDate = DateFormat.yMd().format(DateTime.now()).toString();
  bool dpEnable = false;

  double dailyIncome = 0;

  void calDailyIncome() {
    dailyIncome = 0;
    allInvoices.forEach((invoice) {
      setState(() {
        dailyIncome += invoice.pAmount;
      });
    });
  }

  Future<List<Invoices>> getInvoices() async {
    if (dpEnable == true) {
      return await FirebaseFirestore.instance
          .collection('invoice')
          .where('refName', isEqualTo: LoginSession.refName)
          //.where('customerName', isEqualTo: customerName)
          .where('date', isEqualTo: selectedDate)
          .get()
          .then((value) => value.docs.map((e) => Invoices.fromJson(e.data())).toList());
      /*.snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Invoices.fromJson(doc.data())).toList());*/
    } else {
      return await FirebaseFirestore.instance
          .collection('invoice')
          .where('refName', isEqualTo: LoginSession.refName)
          .get()
          .then((value) => value.docs.map((e) => Invoices.fromJson(e.data())).toList());
      //.where('customerName', isEqualTo: customerName)
      //.where('date', isEqualTo: selectedDate)
      /*.snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Invoices.fromJson(doc.data())).toList());*/
    }
  }

  void _openItemSheet(context, invoiceId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return InvoiceSummaryItemsBottomSheetRef(invoiceId: invoiceId);
        });
  }

  void viewDailyInvoicesSummary(BuildContext context) {
    int totalInvoices = 0, cashInvoices = 0, creditInvoices = 0, chequeInvoices = 0;
    double dailySale = 0, dailyCashSale = 0, dailyCreditSale = 0, dailyChequeSale = 0;

    allInvoices.forEach((invoice) {
      ++totalInvoices;
      dailySale += invoice.netAmount;

      if (invoice.pMethode == 'Cash') {
        ++cashInvoices;
        dailyCashSale += invoice.pAmount;
      } else if (invoice.pMethode == 'Credit') {
        ++creditInvoices;
        dailyCreditSale += invoice.deuAmount;

        dailyCashSale += invoice.pAmount;
      } else if (invoice.pMethode == 'Cheque') {
        ++chequeInvoices;
        dailyChequeSale += invoice.pAmount;
      }
    });

    Navigator.of(context).pushNamed(
      InvoiceSummaryRefView.routeName,
      arguments: InvoiceSummaryRefView(
        allInvoices: allInvoices,
        refName: LoginSession.refName,
        date: DateFormat.yMd().format(DateTime.now()).toString(),
        totalInvoices: totalInvoices,
        cashInvoices: cashInvoices,
        creditInvoices: creditInvoices,
        chequeInvoices: chequeInvoices,
        dailySale: dailySale,
        dailyCashSale: dailyCashSale,
        dailyCreditSale: dailyCreditSale,
        dailyChequeSale: dailyChequeSale,
      ),
    );
  }

  void _getSelectedDate(String date) {
    selectedDate = date;
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
              /*leading: DrawerMenuWidget(
                onClicked: widget.openDrawer,
              ),
              actions: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.table_view,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.add_chart,
                    size: 48,
                  ),
                ),
                const SizedBox(width: 20),
              ],*/
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              floating: true,
              snap: true,
              pinned: true,
              leading: DrawerMenuWidget(
                onClicked: widget.openDrawer,
              ),
              title: Text(
                'Invoice Summary',
                style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 20),
              ),
              actions: [
                /*GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.print, size: 48),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    getInvoices();
                    calDailyIncome();
                  },
                  child: const Icon(Icons.refresh, size: 48),
                ),
                const SizedBox(width: 20),*/
              ],
              expandedHeight: 170,
              flexibleSpace: FlexibleSpaceBar(
                background: InvoiceSummaryAppBar(dailyIncome: dailyIncome, selectedDate: _getSelectedDate, pickedDate: selectedDate),
              ),
              centerTitle: true,
            ),
            /*SliverList(
              delegate: SliverChildListDelegate(
                [
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
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('customers').snapshots(),
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
                                //debugPrint('selected onchange: $value');
                                calDailyIncome();
                                setState(
                                  () {
                                    //calDailyIncome();
                                    //customerName = value.toString();
                                    //debugPrint('make selected: $value');
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
                ],
              ),
            ),*/
          ],
          body: Column(
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
                  future: FirebaseFirestore.instance.collection('customers').get(),
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
                        //debugPrint('selected onchange: $value');
                        calDailyIncome();
                        setState(
                          () {
                            //calDailyIncome();
                            //customerName = value.toString();
                            //debugPrint('make selected: $value');
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
              Expanded(
                child: '' != '' || '' != ''
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        addAutomaticKeepAlives: false,
                        cacheExtent: 100,
                        itemCount: allInvoices.length,
                        itemBuilder: (context, index) {
                          return InvoiceTileWidget(
                            invoices: allInvoices.toList(),
                            index: index,
                            // addProduct: widget.addProduct(allProducts.toList()[index].productName, allProducts.toList()[index].productName, 0, 0),
                            selectInvoice: _openItemSheet,
                          );
                        },
                      )
                    : FutureBuilder<List<Invoices>>(
                        future: getInvoices(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('No Deu Invoiced Found'));
                          } else if (snapshot.hasData) {
                            allInvoices = snapshot.data!;

                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              addAutomaticKeepAlives: false,
                              cacheExtent: 100,
                              itemCount: allInvoices.length,
                              itemBuilder: (context, index) {
                                return InvoiceTileWidget(
                                  invoices: allInvoices.toList(),
                                  index: index,
                                  // addProduct: widget.addProduct(allProducts.toList()[index].productName, allProducts.toList()[index].productName, 0, 0),
                                  selectInvoice: _openItemSheet,
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
            SpeedDialChild(child: const Icon(FontAwesomeIcons.print), label: 'Print', onTap: () => viewDailyInvoicesSummary(context)),
            SpeedDialChild(
                child: const Icon(FontAwesomeIcons.arrowsRotate),
                label: 'Refresh',
                onTap: () {
                  getInvoices();
                  calDailyIncome();
                }),
          ],
        ),
      ),
    );
  }
}
