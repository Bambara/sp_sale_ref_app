import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/invoice_deu.dart';
import 'package:sp_sale_ref_app/models/invoices.dart';
import 'package:sp_sale_ref_app/widgets/deu_invoice_tile_widget.dart';

import '../../widgets/drawer_menu_widget.dart';
import '../sale_ref_drawer/deu_pay_screen.dart';

class InvoiceViewScreenAdmin extends StatefulWidget {
  const InvoiceViewScreenAdmin({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/deu_invoice_screen';
  final VoidCallback openDrawer;

  @override
  State<InvoiceViewScreenAdmin> createState() => _InvoiceViewScreenAdminState();
}

class _InvoiceViewScreenAdminState extends State<InvoiceViewScreenAdmin> {
  var customerName, carMake, carMakeModel;
  var setDefaultMake = true, setDefaultMakeModel = true;
  late List<InvoiceDeu> allDeuInvoices;

  Future<List<Invoices>> getDeuInvoice() async {
    return await FirebaseFirestore.instance.collection('invoice').get().then((value) => value.docs.map((e) => Invoices.fromJson(e.data())).toList());
    // return FirebaseFirestore.instance.collection('invoice').snapshots().map((snapshot) => snapshot.docs.map((doc) => Invoices.fromJson(doc.data())).toList());
  }

  void _openFinalSheet(context, String invoiceId, String customerName, double deuAmount) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return InvoiceDeuPayBottomSheet(invoiceId: invoiceId, customerName: customerName, deuAmount: deuAmount);
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
            actions: [
              const SizedBox(width: 30),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.add_chart,
                  size: 48,
                ),
              ),
              const SizedBox(width: 50),
            ],
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
                        customerName = snapshot.data?.docs[0].get('fname');
                        //debugPrint('setDefault make: $customerName');
                      }
                      return DropdownButton(
                        autofocus: true,
                        enableFeedback: true,
                        isExpanded: true,
                        value: customerName,
                        items: snapshot.data?.docs.map((value) {
                          return DropdownMenuItem(
                            value: value.get('fname'),
                            child: Text('${value.get('fname')}'),
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
              child: '' != '' || '' != ''
                  ? ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: allDeuInvoices.length,
                      itemBuilder: (context, index) {
                        return DeuInvoiceTileWidget(
                          deuInvoices: allDeuInvoices.toList(),
                          index: index,
                          // addProduct: widget.addProduct(allProducts.toList()[index].productName, allProducts.toList()[index].productName, 0, 0),
                          viewPaySheet: _openFinalSheet,
                          viewItemSheet: (context, invoiceId) {},
                        );
                      },
                    )
                  : FutureBuilder<List<Invoices>>(
                      future: getDeuInvoice(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('No Deu Invoiced Found'));
                        } else if (snapshot.hasData) {
                          allDeuInvoices = snapshot.data!.cast<InvoiceDeu>();

                          return ListView.builder(
                            addAutomaticKeepAlives: false,
                            cacheExtent: 100,
                            itemCount: allDeuInvoices.length,
                            itemBuilder: (context, index) {
                              return DeuInvoiceTileWidget(
                                deuInvoices: allDeuInvoices.toList(),
                                index: index,
                                // addProduct: widget.addProduct(allProducts.toList()[index].productName, allProducts.toList()[index].productName, 0, 0),
                                viewItemSheet: (context, invoiceId) {},
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
