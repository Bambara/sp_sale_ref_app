import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/loaded_products.dart';

import 'image_button_widget.dart';

class LoadedProductTileWidget extends StatefulWidget {
  const LoadedProductTileWidget({Key? key, required this.product, required this.index, required this.funDelete, required this.addProduct}) : super(key: key);
  final List<LoadedProducts> product;
  final int index;
  final Function(int index) funDelete;
  final Function(String pCode, String pName, String pImage, double salePrice, double qty) addProduct;

  @override
  State<LoadedProductTileWidget> createState() => _LoadedProductTileWidget();
}

class _LoadedProductTileWidget extends State<LoadedProductTileWidget> {
  final salePriceCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();

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
                Row(children: [Text(widget.product[widget.index].productName.toString(), style: const TextStyle(fontSize: 18))]),
                Row(
                  children: [
                    IconButtonWidget(
                      imagePath: 'assets/icons/delete_sweep.png',
                      function: () {
                        widget.funDelete(widget.index);
                      },
                      isIcon: false,
                      iconData: Icons.adb,
                      color: Colors.black,
                      iconSize: 32,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(children: [
                  const Text('Sale Price ', style: TextStyle(fontSize: 16)),
                  Text(widget.product[widget.index].salePrice.toString(), style: const TextStyle(fontSize: 16))
                ]),
                const SizedBox(width: 10),
                Row(children: [
                  const Text('Qty ', style: TextStyle(fontSize: 16)),
                  Text(widget.product[widget.index].qty.toString(), style: const TextStyle(fontSize: 16)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
