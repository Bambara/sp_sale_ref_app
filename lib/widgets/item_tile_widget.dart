import 'package:flutter/material.dart';

import '../models/invoice_info.dart';
import 'text_button_widget.dart';

class ItemTileWidget extends StatelessWidget {
  const ItemTileWidget({Key? key, required this.soloPlayer, required this.index, required this.function}) : super(key: key);
  final List<InvoiceInfo> soloPlayer;
  final int index;
  final VoidCallback function;

  void get() {
    print('Call');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.redAccent], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(width: 100, height: 100, image: AssetImage("assets/images/tea.jpg"), fit: BoxFit.fill),
            const SizedBox(height: 5),
            const Text('Product Name'),
            Container(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //IconButtonWidget(imagePath: 'imagePath', function: () {}, iconData: Icons.remove, isIcon: true, color: Colors.white),
                  Container(width: 30, height: 20, child: TextField()),
                  //IconButtonWidget(imagePath: 'imagePath', function: () {}, iconData: Icons.add, isIcon: true, color: Colors.white),
                ],
              ),
            ),
            Spacer(),
            TextButtonWidget(title: 'Add', function: function)
          ],
        ),
      ),
    );
  }
}
