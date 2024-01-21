import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:sp_sale_ref_app/data/login_session.dart';
import 'package:sp_sale_ref_app/models/customer.dart';

import '../../widgets/drawer_menu_widget.dart';
import '../../widgets/dropdown_button_widget.dart';
import '../../widgets/form_multi_line_text_field_widget.dart';
import '../../widgets/form_text_field_widget.dart';
import 'customer_register_botom_sheet.dart';

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/customer_reg';
  final VoidCallback openDrawer;

  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  final fNameCtrl = TextEditingController();
  final lNameCtrl = TextEditingController();
  final nicCtrl = TextEditingController();
  final businessNameCtrl = TextEditingController();
  final businessAddressCtrl = TextEditingController();
  final mobileNumberCtrl = TextEditingController();
  String customerType = 'None';
  String discountType = 'None';
  String status = 'None';

  Future<void> _createCustomer() async {
    final customer = Customer(
        fullName: fNameCtrl.text,
        nic: nicCtrl.text,
        mobile_num: mobileNumberCtrl.text,
        bussines_name: businessNameCtrl.text,
        bussines_name_address: businessAddressCtrl.text,
        customer_type: customerType,
        discount_type: discountType,
        refName: LoginSession.refName,
        status: status);

    final customerDoc = FirebaseFirestore.instance.collection('customers').doc(businessNameCtrl.text + '_' + LoginSession.refName);

    await customerDoc.set(customer.toJson()).whenComplete(() {
      Fluttertoast.showToast(
          msg: "Customer Saved !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0);
      clearAll();
    });
  }

  void clearAll() {
    fNameCtrl.text = '';
    nicCtrl.text = '';
    mobileNumberCtrl.text = '';
    businessNameCtrl.text = '';
    businessAddressCtrl.text = '';
    setState(() {
      customerType = 'None';
      discountType = 'None';
      status = 'None';
    });
  }

  void getSelectedCustomerType(String data) {
    setState(() {
      customerType = data;
    });
  }

  void getSelectedDiscountType(String data) {
    setState(() {
      discountType = data;
    });
  }

  void getSelectedStatus(String data) {
    setState(() {
      status = data;
    });
  }

  void getCustomer(String businessName, String refName) async {
    final docEmployee = FirebaseFirestore.instance.collection('customers').doc(businessName + '_' + refName);
    final snapshot = await docEmployee.get();

    if (snapshot.exists) {
      final customer = Customer.fromJson(snapshot.data()!);
      Logger().i(customer.nic);

      fNameCtrl.text = customer.fullName;
      nicCtrl.text = customer.nic;
      businessNameCtrl.text = customer.bussines_name;
      businessAddressCtrl.text = customer.bussines_name_address;
      mobileNumberCtrl.text = customer.mobile_num;
      setState(() {
        customerType = customer.customer_type;
        discountType = customer.discount_type;
        status = customer.status;
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
            /*actions: [
              GestureDetector(
                onTap: () => _openCustomerSheet(context),
                child: const Icon(
                  Icons.table_view,
                  size: 48,
                ),
              ),
              const SizedBox(width: 20),
            ],*/
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            floating: true,
            snap: true,
            title: const Text(
              'Customer Registration',
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
              FormTextFieldWidget(textController: fNameCtrl, hintText: 'Name', isRequired: true, label: 'Name', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormTextFieldWidget(textController: nicCtrl, hintText: 'NIC', isRequired: true, label: 'NIC', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormTextFieldWidget(
                  textController: businessNameCtrl, hintText: 'Business Name', isRequired: true, label: 'Business Name', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormMultiLineTextFieldWidget(
                  textController: businessAddressCtrl, hintText: 'Business Address', isRequired: true, label: 'Business Address', heightFactor: 0.15, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormTextFieldWidget(
                  textController: mobileNumberCtrl, hintText: 'Mobile Number', isRequired: true, label: 'Mobile Number', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              DropDownButtonWidget(
                  valveChoose: customerType,
                  items: const ["None", "Cash", "Cheque", "Credit"],
                  label: 'Customer Type',
                  isRequired: true,
                  selectData: getSelectedCustomerType,
                  widthFactor: 0.9,
                  heightFactor: 0.05),
              const SizedBox(height: 10),
              DropDownButtonWidget(
                  valveChoose: discountType,
                  items: const ["None", "10%", "15%", "20%", "25%"],
                  label: 'Discount Type',
                  isRequired: true,
                  selectData: getSelectedDiscountType,
                  widthFactor: 0.9,
                  heightFactor: 0.05),
              const SizedBox(height: 10),
              DropDownButtonWidget(
                  valveChoose: status,
                  items: const ["None", "Active", "Deactivate"],
                  label: 'Status',
                  isRequired: true,
                  selectData: getSelectedStatus,
                  widthFactor: 0.9,
                  heightFactor: 0.05),
              const SizedBox(height: 10),
              /*FlatButtonWidget(title: "Add Customer", function: _createCustomer, heightFactor: 0.07, widthFactor: 0.7),
              const SizedBox(height: 10),*/
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
          SpeedDialChild(child: const Icon(FontAwesomeIcons.list), label: 'Customer List', onTap: () => _openCustomerSheet(context)),
          SpeedDialChild(
              child: const Icon(Icons.done),
              label: 'Save Customer',
              onTap: () {
                _createCustomer();
              }),
        ],
      ),
    );
  }

  void _openCustomerSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return CustomerRegBottomSheetScreen(selectCustomer: getCustomer);
        });
  }
}
