import 'package:flutter/material.dart';

import '../models/product.dart';
import 'form_number_field_widget.dart';
import 'image_button_widget.dart';

class LoadProductTileWidget extends StatefulWidget {
  const LoadProductTileWidget({Key? key, required this.product, required this.index, required this.addProduct}) : super(key: key);
  final List<Product> product;
  final int index;
  final Function(String pCode, String pName, String pImage, double salePrice, double qty) addProduct;

  @override
  State<LoadProductTileWidget> createState() => _LoadProductTileWidgetState();
}

class _LoadProductTileWidgetState extends State<LoadProductTileWidget> {
  final salePriceCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //void setSalePrice() {
    //salePriceCtrl.text = widget.product[widget.index].salePrice.toString();
    //}

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
                      imagePath: 'assets/icons/done.png',
                      function: () {
                        widget.addProduct(widget.product[widget.index].productCode, widget.product[widget.index].productName, widget.product[widget.index].productImage,
                            double.parse(salePriceCtrl.text), double.parse(qtyCtrl.text));
                      },
                      isIcon: false,
                      iconData: Icons.adb,
                      color: Colors.indigoAccent,
                      iconSize: 48,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormNumberFieldWidget(
                    action: (value) {}, textController: salePriceCtrl, hintText: 'Sale Price', isRequired: true, label: 'Sale Price', heightFactor: 0.055, widthFactor: 0.3),
                const SizedBox(width: 10),
                FormNumberFieldWidget(
                    action: (value) {}, textController: qtyCtrl, hintText: 'Quantity', isRequired: true, label: 'Quantity', heightFactor: 0.055, widthFactor: 0.3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
