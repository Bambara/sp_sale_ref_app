import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../widgets/form_search_text_field_widget.dart';
import '../../widgets/image_button_widget.dart';
import '../../widgets/load_product_tile_widget.dart';

class VehicleLoadBottomSheetScreen extends StatefulWidget {
  const VehicleLoadBottomSheetScreen({Key? key, required this.addProduct}) : super(key: key);

  final Function(String pCode, String pName, String pImage, double salePrice, double qty) addProduct;

  @override
  _VehicleLoadBottomSheetScreenState createState() => _VehicleLoadBottomSheetScreenState();
}

class _VehicleLoadBottomSheetScreenState extends State<VehicleLoadBottomSheetScreen> {
  late List<Product> allProducts;

  Future<List<Product>> getProducts() async {
    return await FirebaseFirestore.instance.collection('products').get().then((value) => value.docs.map((e) => Product.fromJson(e.data())).toList());
    // return FirebaseFirestore.instance.collection('products').snapshots().map((snapshot) => snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }

  void searchProductByPName(String query) {
    final suggestions = allProducts.where((product) {
      final pName = product.productName.toLowerCase();
      final input = query.toLowerCase();

      return pName.startsWith(input);
    }).toList();

    setState(() {
      allProducts = suggestions;
    });
  }

  void searchProductByBCode(String query) {
    final suggestions = allProducts.where((product) {
      final pName = product.barCode;
      final input = query;

      return pName.startsWith(input);
    }).toList();

    setState(() {
      allProducts = suggestions;
    });
  }

  final pNameCtrl = TextEditingController();
  final bCodeCtrl = TextEditingController();

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
                searchProduct: searchProductByBCode,
                textController: bCodeCtrl,
                hintText: 'Bar Code',
                isRequired: true,
                label: 'Bar Code',
                heightFactor: 0.055,
                widthFactor: 0.9),
            const SizedBox(height: 10),
            Expanded(
              child: pNameCtrl.text != '' || bCodeCtrl.text != ''
                  ? ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: allProducts.length,
                      itemBuilder: (context, index) {
                        return LoadProductTileWidget(
                          product: allProducts.toList(),
                          index: index,
                          // addProduct: widget.addProduct(allProducts.toList()[index].productName, allProducts.toList()[index].productName, 0, 0),
                          addProduct: widget.addProduct,
                        );
                      },
                    )
                  : FutureBuilder<List<Product>>(
                      future: getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        } else if (snapshot.hasData) {
                          allProducts = snapshot.data!;

                          return ListView.builder(
                            addAutomaticKeepAlives: false,
                            cacheExtent: 100,
                            itemCount: allProducts.length,
                            itemBuilder: (context, index) {
                              return LoadProductTileWidget(
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
