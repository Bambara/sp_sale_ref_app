import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/customer.dart';
import 'package:sp_sale_ref_app/widgets/customer_tile_widget.dart';

import '../../widgets/image_button_widget.dart';

class CustomerRegBottomSheetScreen extends StatefulWidget {
  const CustomerRegBottomSheetScreen({Key? key, required this.selectCustomer}) : super(key: key);

  final Function(String businessName, String refName) selectCustomer;

  @override
  _CustomerRegBottomSheetScreenState createState() => _CustomerRegBottomSheetScreenState();
}

class _CustomerRegBottomSheetScreenState extends State<CustomerRegBottomSheetScreen> {
  Future<List<Customer>> getCustomers() async => await
      // FirebaseFirestore.instance.collection('customers').snapshots().map((snapshot) => snapshot.docs.map((doc) => Customer.fromJson(doc.data())).toList());
      FirebaseFirestore.instance.collection('customers').get().then((value) => value.docs.map((e) => Customer.fromJson(e.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.6,
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
                  child: const Center(child: Text('Customer List', style: TextStyle(fontSize: 20))),
                ),
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
              child: FutureBuilder<List<Customer>>(
                future: getCustomers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.hasData) {
                    final customers = snapshot.data!;

                    customers.sort((a, b) => a.bussines_name.compareTo(b.bussines_name));

                    return ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: customers.length,
                      itemBuilder: (context, index) {
                        return CustomerTileWidget(
                          customer: customers.toList(),
                          index: index,
                          funDelete: () {},
                          funEdit: widget.selectCustomer,
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
