import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/invoice_items.dart';

class InvoiceSummaryProductTileWidget extends StatefulWidget {
  const InvoiceSummaryProductTileWidget({Key? key, required this.product, required this.index}) : super(key: key);
  final List<InvoiceItems> product;
  final int index;

  @override
  State<InvoiceSummaryProductTileWidget> createState() => _InvoiceSummaryProductTileWidgetState();
}

class _InvoiceSummaryProductTileWidgetState extends State<InvoiceSummaryProductTileWidget> {
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
                Row(children: [Text(widget.product[widget.index].productName.toString(), style: const TextStyle(fontSize: 18, color: Colors.white))]),
                Row(
                  children: [
                    const Text('Qty : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                    Text(widget.product[widget.index].qty.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
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
                    const Text('Price : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                    Text(widget.product[widget.index].salePrice.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Discount : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                    Text((widget.product[widget.index].discountVal * widget.product[widget.index].qty).toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
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
