import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/employee.dart';

import 'image_button_widget.dart';

class EmployeeTileWidget extends StatelessWidget {
  const EmployeeTileWidget({Key? key, required this.employee, required this.index, required this.funDelete, required this.funEdit}) : super(key: key);
  final List<Employee> employee;
  final int index;
  final VoidCallback funDelete;
  final Function(String nic) funEdit;

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
            /*Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [Text(employee[index].fname.toString() + " " + employee[index].lname.toString(), style: const TextStyle(fontSize: 18))]),
                Row(
                  children: [
                    IconButtonWidget(
                      imagePath: 'assets/icons/create.png',
                      function: () {
                        funEdit(employee[index].nic.toString());
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
            Text(employee[index].nic.toString(), style: const TextStyle(fontSize: 0)),
          ],
        ),
      ),
    );
  }
}
