import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/deu_invoice_pay.dart';

import 'image_button_widget.dart';

class DeuPayTileWidget extends StatefulWidget {
  const DeuPayTileWidget({Key? key, required this.invoiceDeuPay, required this.index, required this.viewItemSheet}) : super(key: key);
  final List<DeuInvoicePay> invoiceDeuPay;
  final int index;
  final Function(BuildContext context, String invoiceId) viewItemSheet;

  @override
  State<DeuPayTileWidget> createState() => _DeuPayTileWidgetState();
}

class _DeuPayTileWidgetState extends State<DeuPayTileWidget> {
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
        widget.viewItemSheet(context, widget.invoiceDeuPay[widget.index].invoiceId.toString());
        //debugPrint('Invoice Id :' + widget.invoiceDeuPay[widget.index].id.toString());
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
                    Row(children: [Text(widget.invoiceDeuPay[widget.index].customerName.toString(), style: const TextStyle(fontSize: 18, color: Colors.white))]),
                    SizedBox(width: 150),
                    Row(
                      children: [
                        const Text('Invoice Number : ', style: TextStyle(fontSize: 18, color: Colors.white)),
                        Text(widget.invoiceDeuPay[widget.index].invoiceId.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Row(
                      children: [
                        const Text('Ref Name : ', style: TextStyle(fontSize: 18, color: Colors.white)),
                        Text(widget.invoiceDeuPay[widget.index].refName.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                    SizedBox(width: 65),
                    Row(
                      children: [
                        const Text('Pay Amount : ', style: TextStyle(fontSize: 18, color: Colors.white)),
                        Text(widget.invoiceDeuPay[widget.index].payedAmount.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
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
