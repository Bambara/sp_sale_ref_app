import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/employee.dart';

import 'image_button_widget.dart';

class ReturnTileWidget extends StatelessWidget {
  const ReturnTileWidget({Key? key, required this.employee, required this.index, required this.function}) : super(key: key);
  final List<Employee> employee;
  final int index;
  final VoidCallback function;

  void get() {
    print('Call');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.redAccent], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Customer Name', style: const TextStyle(fontSize: 24)),
              Text(employee[index].fname.toString() + " " + employee[index].lname.toString(), style: const TextStyle(fontSize: 18))
            ]),
            const Divider(
              indent: 5,
              endIndent: 90,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text(employee[index].fname.toString() + " " + employee[index].lname.toString(), style: const TextStyle(fontSize: 18))]),
            const Divider(
              indent: 5,
              endIndent: 90,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [Text(employee[index].fname.toString() + " " + employee[index].lname.toString(), style: const TextStyle(fontSize: 18))]),
                Row(
                  children: [
                    IconButtonWidget(
                      imagePath: 'assets/icons/create.png',
                      function: function,
                      isIcon: false,
                      iconData: Icons.adb,
                      color: Colors.white,
                      iconSize: 32,
                    ),
                    IconButtonWidget(
                      imagePath: 'assets/icons/delete_sweep.png',
                      function: function,
                      isIcon: false,
                      iconData: Icons.adb,
                      color: Colors.white,
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
