import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sp_sale_ref_app/models/employee.dart';
import 'package:sp_sale_ref_app/screens/admin_drawer/employee_register_botom_sheet.dart';
import 'package:sp_sale_ref_app/widgets/date_picker_widget.dart';
import 'package:sp_sale_ref_app/widgets/dropdown_button_widget.dart';

import '../../widgets/drawer_menu_widget.dart';
import '../../widgets/form_multi_line_text_field_widget.dart';
import '../../widgets/form_text_field_widget.dart';

class EmployeeRegistration extends StatefulWidget {
  const EmployeeRegistration({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/admin_dashboard';
  final VoidCallback openDrawer;

  @override
  State<EmployeeRegistration> createState() => _EmployeeRegistrationState();
}

class _EmployeeRegistrationState extends State<EmployeeRegistration> {
  final fNameCtrl = TextEditingController();
  final lNameCtrl = TextEditingController();
  final nicCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileNumberCtrl = TextEditingController();
  String joinDate = DateFormat.yMd().format(DateTime.now()).toString();
  String choosedValue = 'None';

  Future<void> _createEmployee() async {
    final employee = Employee(
        fname: fNameCtrl.text,
        lname: lNameCtrl.text,
        nic: nicCtrl.text,
        mobile_num: mobileNumberCtrl.text,
        email_address: emailCtrl.text,
        address: addressCtrl.text,
        join_date: joinDate,
        status: choosedValue);

    final userDoc = FirebaseFirestore.instance.collection('employees').doc(employee.nic);

    await userDoc.set(employee.toJson());
  }

  void getSelectedDate(String data) {
    setState(() {
      joinDate = data;
    });
  }

  void getSelectedValue(String data) {
    setState(() {
      choosedValue = data;
    });
  }

  void getEmployee(String nic) async {
    final docEmployee = FirebaseFirestore.instance.collection('employees').doc(nic);
    final snapshot = await docEmployee.get();

    if (snapshot.exists) {
      final emp = Employee.fromJson(snapshot.data()!);
      Logger().i(emp.nic);

      fNameCtrl.text = emp.fname;
      lNameCtrl.text = emp.lname;
      nicCtrl.text = emp.nic;
      mobileNumberCtrl.text = emp.mobile_num;
      emailCtrl.text = emp.email_address;
      addressCtrl.text = emp.address;
      setState(() {
        joinDate = emp.join_date;
        choosedValue = emp.status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            leading: DrawerMenuWidget(
              onClicked: widget.openDrawer,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            floating: true,
            snap: true,
            title: const Text(
              'Employee Registration',
              style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 20),
            ),
            centerTitle: true,
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FormTextFieldWidget(textController: fNameCtrl, hintText: 'First Name', isRequired: true, label: 'First Name', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormTextFieldWidget(textController: lNameCtrl, hintText: 'Last Name', isRequired: true, label: 'Last Name', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormTextFieldWidget(textController: nicCtrl, hintText: 'NIC', isRequired: true, label: 'NIC', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormMultiLineTextFieldWidget(textController: addressCtrl, hintText: 'Address', isRequired: true, label: 'Address', heightFactor: 0.15, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormTextFieldWidget(textController: emailCtrl, hintText: 'Email', isRequired: true, label: 'Email', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormTextFieldWidget(
                  textController: mobileNumberCtrl, hintText: 'Mobile Number', isRequired: true, label: 'Mobile Number', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              DatePickerWidget(pickedDate: joinDate, selectedDate: getSelectedDate, label: 'Join Date', isRequired: true, widthFactor: 0.9, heightFactor: 0.055),
              const SizedBox(height: 10),
              DropDownButtonWidget(
                  valveChoose: choosedValue,
                  items: const ["None", "Active", "Deactivate"],
                  label: 'Status',
                  isRequired: true,
                  selectData: getSelectedValue,
                  widthFactor: 0.9,
                  heightFactor: 0.05),
              const SizedBox(height: 10),
              // FlatButtonWidget(title: "Save Employee", function: () => _createEmployee(), heightFactor: 0.07, widthFactor: 0.7),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10,
        children: [
          SpeedDialChild(child: const Icon(FontAwesomeIcons.list), label: 'Employee List', onTap: () => _openEmployeeSheet(context)),
          SpeedDialChild(child: const Icon(Icons.save), label: 'Save Employee', onTap: () => _createEmployee()),
        ],
      ),
    );
  }

  void _openEmployeeSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return EmployeeRegBottomSheetScreen(getEmp: getEmployee);
        });
  }
}
