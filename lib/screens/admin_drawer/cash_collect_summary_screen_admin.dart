import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sp_sale_ref_app/models/deu_invoice_pay.dart';

import '../../api/pdf/cash_collect_summary_ref/cash_collect_summary_ref_view.dart';
import '../../widgets/cash_collect_summary_app_bar.dart';
import '../../widgets/date_picker_widget.dart';
import '../../widgets/deu_pay_tile_widget.dart';
import '../../widgets/drawer_menu_widget.dart';
import 'invoice_summary_items_bottom_screen_admin.dart';

class CashCollectSummaryScreenAdmin extends StatefulWidget {
  const CashCollectSummaryScreenAdmin({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/invoice_summary_screen';
  final VoidCallback openDrawer;

  @override
  State<CashCollectSummaryScreenAdmin> createState() => _CashCollectSummaryScreenAdminState();
}

class _CashCollectSummaryScreenAdminState extends State<CashCollectSummaryScreenAdmin> {
  late List<DeuInvoicePay> allCollections;
  var customerName;
  var refName;
  var setDefaultMake = true, setDefaultMakeModel = true;
  var setDefaultMakeRef = true, setDefaultMakeModelRef = true;
  var selectedDate = DateFormat.yMd().format(DateTime.now()).toString();
  bool dpEnable = false;

  double dailyCollection = 0;

  void calDailyIncome() {
    dailyCollection = 0;
    allCollections.forEach((invoice) {
      setState(() {
        dailyCollection += invoice.payedAmount;
        print(dailyCollection);
      });
    });
  }

  Future<List<DeuInvoicePay>> getDeuPayList() async {
    if (dpEnable == true) {
      return await FirebaseFirestore.instance
          .collection('deu_invoice_pay')
          //.where('refName', isEqualTo: LoginSession.refName)
          //.where('customerName', isEqualTo: customerName)
          .where('payedDate', isEqualTo: selectedDate)
          /*.snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => DeuInvoicePay.fromJson(doc.data())).toList());*/
          .get()
          .then((value) => value.docs.map((e) => DeuInvoicePay.fromJson(e.data())).toList());
    } else {
      return FirebaseFirestore.instance
          .collection('deu_invoice_pay')
          //.where('refName', isEqualTo: LoginSession.refName)
          //.where('customerName', isEqualTo: customerName)
          //.where('payedDate', isEqualTo: selectedDate)
          /*.snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => DeuInvoicePay.fromJson(doc.data())).toList());*/
          .get()
          .then((value) => value.docs.map((e) => DeuInvoicePay.fromJson(e.data())).toList());
    }
  }

  void searchProductByCustomer(String query) {
    final suggestions = allCollections.where((product) {
      final cusName = product.customerName.toLowerCase();
      final input = query.toLowerCase();

      return cusName.startsWith(input);
    }).toList();

    setState(() {
      allCollections = suggestions;
    });
  }

  void searchProductByRef(String query) {
    final suggestions = allCollections.where((product) {
      final refName = product.refName.toLowerCase();
      final input = query.toLowerCase();

      return refName.startsWith(input);
    }).toList();

    setState(() {
      allCollections = suggestions;
    });
  }

  void viewDailyCashCollectSummary(BuildContext context) {
    int totalInvoices = 0, cashInvoices = 0, creditInvoices = 0, chequeInvoices = 0;
    double dailyCollect = 0, totalDeu = 0, dailyCreditSale = 0, dailyChequeSale = 0;

    allCollections.forEach((invoice) {
      ++totalInvoices;
      dailyCollect += invoice.payedAmount;
      totalDeu += invoice.deuAmount;
    });

    Navigator.of(context).pushNamed(
      CashCollectSummaryRefView.routeName,
      arguments: CashCollectSummaryRefView(
        allCollections: allCollections,
        refName: refName,
        date: DateFormat.yMd().format(DateTime.now()).toString(),
        totalInvoices: totalInvoices,
        totalCashCollect: dailyCollect,
        totalDeu: totalDeu,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              floating: true,
              snap: true,
              pinned: true,
              actions: [
                /*GestureDetector(
                  onTap: () {
                    viewDailyCashCollectSummary(context);
                  },
                  child: const Icon(
                    Icons.print,
                    size: 48,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      setDefaultMakeRef = true;
                    });

                    getDeuPayList();
                    calDailyIncome();
                  },
                  child: const Icon(
                    Icons.refresh,
                    size: 48,
                  ),
                ),
                SizedBox(
                  width: 50,
                )*/
              ],
              leading: DrawerMenuWidget(
                onClicked: widget.openDrawer,
              ),
              title: Text(
                'Cash Collect Summary',
                style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 20),
              ),
              expandedHeight: 170,
              flexibleSpace: FlexibleSpaceBar(
                background: CashCollectSummaryAppBar(dailyIncome: dailyCollection),
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
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                                searchProductByRef(value.toString());
                                calDailyIncome();
                                //debugPrint('selected onchange: $value');
                                //getInvoices();
                                //calDailyIncome();
                                setState(
                                  () {
                                    searchProductByRef(value.toString());
                                    calDailyIncome();
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
                            false
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
                                searchProductByCustomer(value.toString());
                                calDailyIncome();
                                setState(
                                  () {
                                    //calDailyIncome();
                                    //customerName = value.toString();
                                    //debugPrint('make selected: $value');
                                    // Selected value will be stored
                                    // Default dropdown value won't be displayed anymore
                                    setDefaultMake = false;
                                    // Set makeModel to true to display first car from list
                                    setDefaultMakeModel = true;
                                    customerName = value;
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
                        searchProductByRef(value.toString());
                        calDailyIncome();
                        //debugPrint('selected onchange: $value');
                        //getInvoices();
                        //calDailyIncome();
                        setState(
                          () {
                            searchProductByRef(value.toString());
                            calDailyIncome();
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
                    false
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
                        searchProductByCustomer(value.toString());
                        calDailyIncome();
                        setState(
                          () {
                            //calDailyIncome();
                            //customerName = value.toString();
                            //debugPrint('make selected: $value');
                            // Selected value will be stored
                            // Default dropdown value won't be displayed anymore
                            setDefaultMake = false;
                            // Set makeModel to true to display first car from list
                            setDefaultMakeModel = true;
                            customerName = value;
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: setDefaultMake == false || setDefaultMakeRef == false
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        addAutomaticKeepAlives: false,
                        cacheExtent: 100,
                        itemCount: allCollections.length,
                        itemBuilder: (context, index) {
                          allCollections.sort((a, b) => a.invoiceId.compareTo(b.invoiceId));

                          return DeuPayTileWidget(
                            invoiceDeuPay: allCollections.toList(),
                            viewItemSheet: _openItemSheet,
                            index: index,
                          );
                        },
                      )
                    : FutureBuilder<List<DeuInvoicePay>>(
                        future: getDeuPayList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('No Deu Invoiced Found'));
                          } else if (snapshot.hasData) {
                            allCollections = snapshot.data!;

                            allCollections.sort((a, b) => a.invoiceId.compareTo(b.invoiceId));

                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              addAutomaticKeepAlives: false,
                              cacheExtent: 100,
                              itemCount: allCollections.length,
                              itemBuilder: (context, index) {
                                return DeuPayTileWidget(
                                  invoiceDeuPay: allCollections.toList(),
                                  viewItemSheet: _openItemSheet,
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
        floatingActionButton: SpeedDial(
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          animatedIcon: AnimatedIcons.menu_close,
          spacing: 10,
          children: [
            SpeedDialChild(
              child: const Icon(FontAwesomeIcons.arrowsRotate),
              label: 'Current Stock',
              onTap: () {
                setState(() {
                  setDefaultMakeRef = true;
                  setDefaultMake = true;
                });

                getDeuPayList();
                calDailyIncome();
              },
            ),
            SpeedDialChild(
              child: const Icon(FontAwesomeIcons.print),
              label: 'Daily Collection Report',
              onTap: () {
                viewDailyCashCollectSummary(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
