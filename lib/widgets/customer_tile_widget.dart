import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/customer.dart';

import 'image_button_widget.dart';

class CustomerTileWidget extends StatelessWidget {
  const CustomerTileWidget({Key? key, required this.customer, required this.index, required this.funDelete, required this.funEdit}) : super(key: key);
  final List<Customer> customer;
  final int index;
  final VoidCallback funDelete;
  final Function(String businessName, String refName) funEdit;

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
                Row(children: [Text(customer[index].bussines_name.toString(), style: const TextStyle(fontSize: 18))]),
                Row(children: [Text(customer[index].refName.toString(), style: const TextStyle(fontSize: 18))]),
                Row(
                  children: [
                    IconButtonWidget(
                      imagePath: 'assets/icons/create.png',
                      function: () {
                        funEdit(customer[index].bussines_name.toString(), customer[index].refName.toString());
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
