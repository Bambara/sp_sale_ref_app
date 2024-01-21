import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/vehicle_stock.dart';
import 'form_number_field_widget.dart';
import 'image_button_widget.dart';

class InvoiceProductTileWidget extends StatefulWidget {
  const InvoiceProductTileWidget({Key? key, required this.product, required this.index, required this.addProduct}) : super(key: key);
  final List<VehicleStock> product;
  final int index;
  final Function(String pCode, String pName, double salePrice, double discountVal, double qty, double aveQty) addProduct;

  @override
  State<InvoiceProductTileWidget> createState() => _InvoiceProductTileWidgetState();
}

class _InvoiceProductTileWidgetState extends State<InvoiceProductTileWidget> {
  final discountCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();

  Future<Widget> loadImage(BuildContext context, String fileName) async {
    Image image = Image.asset('assets/images/hand-sanitizer.png', width: 200, height: 200);
    await FireStorageService.loadImage(context, fileName).then((value) {
      image = Image.network(value.toString(), width: 100, height: 100);
    });
    return image;
  }

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [Text(widget.product[widget.index].pName.toString(), style: const TextStyle(fontSize: 18, color: Colors.white))]),
                Row(
                  children: [
                    const Text('A. Qty : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                    Text(widget.product[widget.index].qty.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
                widget.product[widget.index].qty <= 5
                    ? Row(
                        children: [
                          IconButtonWidget(
                            imagePath: 'assets/icons/exclamation_mark.png',
                            function: () {
                              discountCtrl.text == ''
                                  ? widget.addProduct(widget.product[widget.index].pCode, widget.product[widget.index].pName, widget.product[widget.index].salePrice, 0,
                                      double.parse(qtyCtrl.text), widget.product[widget.index].qty)
                                  : widget.addProduct(widget.product[widget.index].pCode, widget.product[widget.index].pName, widget.product[widget.index].salePrice,
                                      double.parse(discountCtrl.text), double.parse(qtyCtrl.text), widget.product[widget.index].qty);
                            },
                            isIcon: false,
                            iconData: Icons.adb,
                            color: Colors.black,
                            iconSize: 48,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          IconButtonWidget(
                            imagePath: 'assets/icons/done.png',
                            function: () {
                              widget.addProduct(widget.product[widget.index].pCode, widget.product[widget.index].pName, widget.product[widget.index].salePrice,
                                  double.parse(discountCtrl.text), double.parse(qtyCtrl.text), widget.product[widget.index].qty);
                            },
                            isIcon: false,
                            iconData: Icons.adb,
                            color: Colors.green,
                            iconSize: 48,
                          ),
                        ],
                      )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*FormNumberFieldWidget(
                        action: (value) {}, textController: salePriceCtrl, hintText: 'Sale Price', isRequired: true, label: 'Sale Price', heightFactor: 0.055, widthFactor: 0.2),*/
                Row(
                  children: [
                    const Text('Price : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                    Text(widget.product[widget.index].salePrice.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
                FormNumberFieldWidget(
                    action: (value) {}, textController: qtyCtrl, hintText: 'Quantity', isRequired: true, label: 'Quantity', heightFactor: 0.07, widthFactor: 0.2),
                FormNumberFieldWidget(
                    action: (value) {}, textController: discountCtrl, hintText: 'Discount', isRequired: true, label: 'Discount', heightFactor: 0.07, widthFactor: 0.2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, String fileName) async {
    return await FirebaseStorage.instance.ref('product_images/').child(fileName).getDownloadURL();
  }
}
