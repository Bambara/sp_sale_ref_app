import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/vehicle_stock.dart';

import '../../data/login_session.dart';
import '../../widgets/form_search_text_field_widget.dart';
import '../../widgets/image_button_widget.dart';
import '../../widgets/invoice_product_tile_widget.dart';

class InvoiceLoadBottomSheetScreen extends StatefulWidget {
  const InvoiceLoadBottomSheetScreen({Key? key, required this.addProduct}) : super(key: key);

  final Function(String pCode, String pName, double salePrice, double discountVal, double qty, double aveQty) addProduct;

  @override
  _InvoiceLoadBottomSheetScreenState createState() => _InvoiceLoadBottomSheetScreenState();
}

class _InvoiceLoadBottomSheetScreenState extends State<InvoiceLoadBottomSheetScreen> {
  late List<VehicleStock> allProducts;

  Future<List<VehicleStock>> getProducts() async {
    return await FirebaseFirestore.instance
        .collection('vehicle_stock')
        .where('vehicleNum', isEqualTo: LoginSession.vehicleNum)
        .where('qty', isGreaterThan: 0)
        .get()
        .then((value) => value.docs.map((e) => VehicleStock.fromJson(e.data())).toList());
    /*.snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => VehicleStock.fromJson(doc.data())).toList());*/
  }

  void searchProductByPName(String query) {
    final suggestions = allProducts.where((product) {
      final pName = product.pName.toLowerCase();
      final input = query.toLowerCase();

      return pName.startsWith(input);
    }).toList();

    setState(() {
      allProducts = suggestions;
    });
  }

  void searchProductByPCode(String query) {
    final suggestions = allProducts.where((product) {
      final pName = product.pCode.toLowerCase();
      final input = query.toLowerCase();

      return pName.startsWith(input);
    }).toList();

    setState(() {
      allProducts = suggestions;
    });
  }

  final pNameCtrl = TextEditingController();
  final pCodeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.9,
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
                  child: const Center(child: Text('Product List', style: TextStyle(fontSize: 20))),
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
            FormSearchTextFieldWidget(
                searchProduct: searchProductByPName,
                textController: pNameCtrl,
                hintText: 'Product Name',
                isRequired: true,
                label: 'Product Name',
                heightFactor: 0.055,
                widthFactor: 0.9),
            const SizedBox(height: 10),
            FormSearchTextFieldWidget(
                searchProduct: searchProductByPCode,
                textController: pCodeCtrl,
                hintText: 'Product Code',
                isRequired: true,
                label: 'Product Code',
                heightFactor: 0.055,
                widthFactor: 0.9),
            const SizedBox(height: 10),
            Expanded(
              child: pNameCtrl.text != '' || pCodeCtrl.text != ''
                  ? ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: allProducts.length,
                      itemBuilder: (context, index) {
                        allProducts.sort((a, b) => a.pName.compareTo(b.pName));

                        return InvoiceProductTileWidget(
                          product: allProducts.toList(),
                          index: index,
                          addProduct: widget.addProduct,
                        );
                      },
                    )
                  : FutureBuilder<List<VehicleStock>>(
                      future: getProducts(),
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
                              return InvoiceProductTileWidget(
                                product: allProducts.toList(),
                                index: index,
                                // addProduct: widget.addProduct(allProducts.toList()[index].productName, allProducts.toList()[index].productName, 0, 0),
                                addProduct: widget.addProduct,
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
