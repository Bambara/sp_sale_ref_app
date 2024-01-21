import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/data/app_colors.dart';
import 'package:sp_sale_ref_app/data/login_session.dart';
import 'package:sp_sale_ref_app/screens/admin_drawer/invoice_summary_screen_admin.dart';
import 'package:sp_sale_ref_app/screens/admin_drawer/product_registration.dart';
import 'package:sp_sale_ref_app/screens/admin_drawer/vehicle_load_screen.dart';
import 'package:sp_sale_ref_app/screens/admin_drawer/vehicle_stock_screen.dart';

import '../../data/admin_drawer_items.dart';
import '../../models/drawer_item.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/image_button_widget.dart';
import 'admin_dashboard.dart';
import 'cash_collect_summary_screen_admin.dart';
import 'customer_registration.dart';
import 'employee_registration.dart';
import 'vehicle_registration.dart';

class AdminDrawerScreen extends StatefulWidget {
  static const routeName = '/admin_drawer_screen';

  const AdminDrawerScreen({Key? key}) : super(key: key);

  @override
  State<AdminDrawerScreen> createState() => _AdminDrawerScreenState();
}

class _AdminDrawerScreenState extends State<AdminDrawerScreen> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  bool isDragging = false;
  late bool isDrawerOpen;
  DrawerItem item = AdminDrawerItems.dashBoard;

  @override
  void initState() {
    closeDrawer();
  }

  @override
  void dispose() {}

  void openDrawer() {
    setState(() {
      xOffset = 250;
      yOffset = 150;
      scaleFactor = 0.7;
      isDragging = true;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDragging = false;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(children: [
        buildDrawer(),
        buildPage(context),
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildDrawer() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildUserArea(),
          SizedBox(
            width: xOffset,
            child: DrawerWidget(
              onSelectedItem: (item) {
                setState(() => this.item = item);
                closeDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserArea() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.15,
        margin: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.06,
                  backgroundImage: const AssetImage('assets/images/person_outline.png'),
                  backgroundColor: Colors.grey.shade600,
                  child: Text(LoginSession.userName[0].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LoginSession.userName, style: const TextStyle(color: Colors.black54, fontSize: 20)),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButtonWidget(
                    imagePath: 'assets/images/lock.png',
                    function: () {
                      LoginSession.vehicleNum = '';
                      LoginSession.refName = '';
                      LoginSession.userName = '';
                      LoginSession.userType = '';
                      Navigator.of(context).popAndPushNamed('/');
                    },
                    isIcon: false,
                    iconData: Icons.adb,
                    color: Colors.black,
                    iconSize: 64),
              ],
            )
          ],
        ));
  }

  Widget buildPage(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        /*onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },*/
        onTap: closeDrawer,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
              child: Container(
                color: isDrawerOpen ? AppColors.black12 : Theme.of(context).primaryColor,
                child: getDrawerPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerPage() {
    if (AdminDrawerItems.dashBoard == item) {
      return AdminDashboard(openDrawer: openDrawer);
    } else if (AdminDrawerItems.customerReg == item) {
      return CustomerRegistration(openDrawer: openDrawer);
    } else if (AdminDrawerItems.employeeReg == item) {
      return EmployeeRegistration(openDrawer: openDrawer);
    } else if (AdminDrawerItems.productReg == item) {
      return ProductRegistration(openDrawer: openDrawer);
    } else if (AdminDrawerItems.vehicleReg == item) {
      return VehicleRegistration(openDrawer: openDrawer);
    } else if (AdminDrawerItems.vehicleLoad == item) {
      return VehicleLoadScreen(openDrawer: openDrawer);
    }
    /*else if (AdminDrawerItems.deuInvoice == item) {
      // return DeuInvoiceScreenAdmin(openDrawer: openDrawer);
    }*/
    else if (AdminDrawerItems.cashCollectSummary == item) {
      return CashCollectSummaryScreenAdmin(openDrawer: openDrawer);
    }
    /*else if (AdminDrawerItems.invoice == item) {
      // return InvoiceAdmin(openDrawer: openDrawer);
    }*/
    else if (AdminDrawerItems.invoiceSummary == item) {
      return InvoiceSummaryScreenAdmin(openDrawer: openDrawer);
    } else if (AdminDrawerItems.vehicleStock == item) {
      return VehicleStockScreenAdmin(openDrawer: openDrawer);
    } else {
      return AdminDashboard(openDrawer: openDrawer);
    }
  }
}
