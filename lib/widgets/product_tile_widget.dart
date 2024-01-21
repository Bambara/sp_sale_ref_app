import 'package:flutter/material.dart';

import '../models/product.dart';
import 'image_button_widget.dart';

class ProductTileWidget extends StatelessWidget {
  const ProductTileWidget({Key? key, required this.product, required this.index, required this.funDelete, required this.funEdit}) : super(key: key);
  final List<Product> product;
  final int index;
  final VoidCallback funDelete;
  final Function(String nic) funEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.redAccent], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [Text(product[index].productName.toString(), style: const TextStyle(fontSize: 18))]),
                Row(
                  children: [
                    IconButtonWidget(
                      imagePath: 'assets/icons/create.png',
                      function: () {
                        funEdit(product[index].productCode.toString());
                        Navigator.of(context).pop();
                      },
                      isIcon: false,
                      iconData: Icons.adb,
                      color: Colors.black,
                      iconSize: 32,
                    ),
                    IconButtonWidget(
                      imagePath: 'assets/icons/delete_sweep.png',
                      function: funDelete,
                      isIcon: false,
                      iconData: Icons.adb,
                      color: Colors.black,
                      iconSize: 32,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
