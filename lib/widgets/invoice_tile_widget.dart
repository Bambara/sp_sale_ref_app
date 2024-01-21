import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/invoices.dart';
import 'image_button_widget.dart';

class InvoiceTileWidget extends StatefulWidget {
  const InvoiceTileWidget({Key? key, required this.invoices, required this.index, required this.selectInvoice}) : super(key: key);
  final List<Invoices> invoices;
  final int index;
  final Function(BuildContext context, String invoiceId) selectInvoice;

  @override
  State<InvoiceTileWidget> createState() => _InvoiceTileWidgetState();
}

class _InvoiceTileWidgetState extends State<InvoiceTileWidget> {
  final salePriceCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();

  @override
  void initState() {
    //setSalePrice();
  }

  /*void setSalePrice() {
    salePriceCtrl.text = widget.product[widget.index].salePrice.toString();
  }*/

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
      onTap: () {
        widget.selectInvoice(context, widget.invoices[widget.index].id.toString());
        //debugPrint('Invoice Id :' + widget.invoices[widget.index].id.toString());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.redAccent], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [Text(widget.invoices[widget.index].customerName.toString(), style: const TextStyle(fontSize: 18, color: Colors.white))]),
                    SizedBox(width: 50),
                    Row(
                      children: [
                        const Text('Invoice Number : ', style: TextStyle(fontSize: 18, color: Colors.white)),
                        Text(widget.invoices[widget.index].id.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Ref Name : ', style: TextStyle(fontSize: 18, color: Colors.white)),
                        Text(widget.invoices[widget.index].refName.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  ],
                ),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(
                    children: [
                      const Text('Pay Methode : ', style: TextStyle(fontSize: 18, color: Colors.white)),
                      Text(widget.invoices[widget.index].pMethode.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Row(
                    children: [
                      const Text('Pay Amount : ', style: TextStyle(fontSize: 18, color: Colors.white)),
                      Text(widget.invoices[widget.index].pAmount.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ])
              ],
            ),
            Row(
              children: [
                IconButtonWidget(imagePath: 'assets/icons/delete_sweep.png', function: () {}, isIcon: false, iconData: Icons.adb, color: Colors.black, iconSize: 48),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

/**/
  static Future<dynamic> loadImage(BuildContext context, String fileName) async {
    return await FirebaseStorage.instance.ref('product_images/').child(fileName).getDownloadURL();
  }
}
