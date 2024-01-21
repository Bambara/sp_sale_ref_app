import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../data/login_session.dart';
import '../../models/invoice_deu.dart';
import '../../widgets/deu_invoice_tile_widget.dart';
import '../../widgets/drawer_menu_widget.dart';
import 'deu_pay_screen.dart';
import 'invoice_summary_items_bottom_screen_ref.dart';

class DeuInvoiceScreenRef extends StatefulWidget {
  const DeuInvoiceScreenRef({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/deu_invoice_screen';
  final VoidCallback openDrawer;

  @override
  State<DeuInvoiceScreenRef> createState() => _DeuInvoiceScreenRefState();
}

class _DeuInvoiceScreenRefState extends State<DeuInvoiceScreenRef> {
  var customerName, carMake, carMakeModel;
  var setDefaultMake = true, setDefaultMakeModel = true;
  late List<InvoiceDeu> allInvoices;

  Future<List<InvoiceDeu>> _getDeuInvoices() async {
    return await FirebaseFirestore.instance
        .collection('deu_invoice')
        //.where('invoiceNumber', isGreaterThan: 0)
        .where('refName', isEqualTo: LoginSession.refName)
        .where('deuAmount', isGreaterThan: 0)
        .get()
        .then((value) => value.docs.map((e) => InvoiceDeu.fromJson(e.data())).toList());
  }

  void searchInvoicesByCustomer(String query) {
    final suggestions = allInvoices.where((product) {
      final cusName = product.customerName.toLowerCase();
      final input = query.toLowerCase();

      return cusName.startsWith(input);
    }).toList();

    setState(() {
      allInvoices = suggestions;
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

  void _openItemSheet(context, invoiceId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          // return InvoiceSummaryItemsBottomSheetAdmin(invoiceId: invoiceId, refName: LoginSession.refName);
          return InvoiceSummaryItemsBottomSheetRef(invoiceId: invoiceId);
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
              'Cash Collect',
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
              child: setDefaultMake == false
                  ? ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: allInvoices.length,
                      itemBuilder: (context, index) {
                        allInvoices.sort((a, b) => a.invoiceNumber.compareTo(b.invoiceNumber));
                        return DeuInvoiceTileWidget(
                          deuInvoices: allInvoices.toList(),
                          index: index,
                          viewItemSheet: _openItemSheet,
                          viewPaySheet: _openFinalSheet,
                        );
                      },
                    )
                  : FutureBuilder<List<InvoiceDeu>>(
                      future: _getDeuInvoices(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('No Deu Invoices Found'));
                        } else if (snapshot.hasData) {
                          allInvoices = snapshot.data!;

                          allInvoices.sort((a, b) => a.invoiceNumber.compareTo(b.invoiceNumber));

                          return ListView.builder(
                            addAutomaticKeepAlives: false,
                            cacheExtent: 100,
                            itemCount: allInvoices.length,
                            itemBuilder: (context, index) {
                              return DeuInvoiceTileWidget(
                                deuInvoices: allInvoices.toList(),
                                index: index,
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
    );
  }
}
