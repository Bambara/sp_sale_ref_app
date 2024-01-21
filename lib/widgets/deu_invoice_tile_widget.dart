import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/invoice_deu.dart';

import 'image_button_widget.dart';

class DeuInvoiceTileWidget extends StatefulWidget {
  const DeuInvoiceTileWidget({Key? key, required this.deuInvoices, required this.index, required this.viewPaySheet, required this.viewItemSheet}) : super(key: key);
  final List<InvoiceDeu> deuInvoices;
  final int index;
  final Function(BuildContext context, String invoiceId, String customerName, double deuAmount) viewPaySheet;
  final Function(BuildContext context, String invoiceId) viewItemSheet;

  @override
  State<DeuInvoiceTileWidget> createState() => _DeuInvoiceTileWidgetState();
}

class _DeuInvoiceTileWidgetState extends State<DeuInvoiceTileWidget> {
  @override
  void initState() {
    super.initState();

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
        widget.viewItemSheet(context, widget.deuInvoices[widget.index].invoiceNumber.toString());
        //Logger().i(widget.deuInvoices[widget.index].invoiceNumber.toString());
      },
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
                Row(children: [Text(widget.deuInvoices[widget.index].customerName.toString(), style: const TextStyle(fontSize: 16, color: Colors.white))]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('#', style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text(widget.deuInvoices[widget.index].invoiceNumber.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    IconButtonWidget(
                      imagePath: 'assets/icons/money.png',
                      function: () {
                        widget.viewPaySheet(context, widget.deuInvoices[widget.index].invoiceNumber.toString(), widget.deuInvoices[widget.index].customerName,
                            widget.deuInvoices[widget.index].deuAmount);
                      },
                      isIcon: false,
                      iconData: Icons.adb,
                      color: Colors.black,
                      iconSize: 48,
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Ref Number : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                    Text(widget.deuInvoices[widget.index].refName.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Deu Amount : ', style: TextStyle(fontSize: 16, color: Colors.white)),
                    Text(widget.deuInvoices[widget.index].deuAmount.toString(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    IconButtonWidget(
                      imagePath: 'assets/icons/delete_sweep.png',
                      function: () {},
                      isIcon: false,
                      iconData: Icons.adb,
                      color: Colors.black,
                      iconSize: 48,
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

class FireStorageService extends ChangeNotifier {
  FireStorageService();

/**/
  static Future<dynamic> loadImage(BuildContext context, String fileName) async {
    return await FirebaseStorage.instance.ref('product_images/').child(fileName).getDownloadURL();
  }
}
