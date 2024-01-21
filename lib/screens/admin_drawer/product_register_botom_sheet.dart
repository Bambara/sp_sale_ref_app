import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../widgets/image_button_widget.dart';
import '../../widgets/product_tile_widget.dart';

class ProductRegBottomSheetScreen extends StatefulWidget {
  const ProductRegBottomSheetScreen({Key? key, required this.selectProduct}) : super(key: key);

  final Function(String pCode) selectProduct;

  @override
  _ProductRegBottomSheetScreenState createState() => _ProductRegBottomSheetScreenState();
}

class _ProductRegBottomSheetScreenState extends State<ProductRegBottomSheetScreen> {
  Future<List<Product>> getProducts() async =>
      await FirebaseFirestore.instance.collection('products').get().then((value) => value.docs.map((e) => Product.fromJson(e.data())).toList());

  // FirebaseFirestore.instance.collection('products').snapshots().map((snapshot) => snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.8,
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
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.hasData) {
                    final products = snapshot.data!;

                    return ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductTileWidget(
                          product: products.toList(),
                          index: index,
                          funDelete: () {},
                          funEdit: widget.selectProduct,
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
