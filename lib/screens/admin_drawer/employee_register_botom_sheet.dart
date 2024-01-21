import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/employee.dart';

import '../../widgets/employee_tile_widget.dart';
import '../../widgets/image_button_widget.dart';

class EmployeeRegBottomSheetScreen extends StatefulWidget {
  const EmployeeRegBottomSheetScreen({Key? key, required this.getEmp}) : super(key: key);

  final Function(String nic) getEmp;

  @override
  _EmployeeRegBottomSheetScreenState createState() => _EmployeeRegBottomSheetScreenState();
}

class _EmployeeRegBottomSheetScreenState extends State<EmployeeRegBottomSheetScreen> {
  Future<List<Employee>> getEmployees() async =>
      await FirebaseFirestore.instance.collection('employees').get().then((value) => value.docs.map((e) => Employee.fromJson(e.data())).toList());

  // FirebaseFirestore.instance.collection('employees').snapshots().map((snapshot) => snapshot.docs.map((doc) => Employee.fromJson(doc.data())).toList());

  void getEmp_01(String nic) {
    widget.getEmp(nic);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Center(child: Text('Employee List', style: TextStyle(fontSize: 20))),
                ),
                IconButtonWidget(
                    imagePath: '',
                    function: () {
                      Navigator.of(context).pop();
                    },
                    iconData: Icons.close,
                    isIcon: true,
                    iconSize: 32,
                    color: Colors.black)
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Employee>>(
                future: getEmployees(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.hasData) {
                    final employees = snapshot.data!;

                    return ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        return EmployeeTileWidget(
                          employee: employees.toList(),
                          index: index,
                          funDelete: () {},
                          funEdit: widget.getEmp,
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
