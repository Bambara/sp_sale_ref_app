import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/screens/sale_ref_drawer/customer_registration.dart';
import 'package:sp_sale_ref_app/screens/sale_ref_drawer/deu_invoice_screen.dart';
import 'package:sp_sale_ref_app/screens/sale_ref_drawer/invoice.dart';
import 'package:sp_sale_ref_app/screens/sale_ref_drawer/invoice_summary_screen_ref.dart';
import 'package:sp_sale_ref_app/screens/sale_ref_drawer/vehicle_stock_screen_ref.dart';

import '../../data/login_session.dart';
import '../../data/ref_drawer_items.dart';
import '../../models/drawer_item.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/image_button_widget.dart';
import 'cash_collect_summary_screen_ref.dart';
import 'dashboard.dart';

class RefDrawerScreen extends StatefulWidget {
  static const routeName = '/ref_drawer_screen';

  const RefDrawerScreen({Key? key}) : super(key: key);

  @override
  State<RefDrawerScreen> createState() => _RefDrawerScreenState();
}

class _RefDrawerScreenState extends State<RefDrawerScreen> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  bool isDragging = false;
  late bool isDrawerOpen;
  DrawerItem item = RefDrawerItems.dashBoard;

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
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LoginSession.userName, style: TextStyle(color: Colors.black54, fontSize: 20)),
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
                color: isDrawerOpen ? Colors.white12 : Theme.of(context).primaryColor,
                child: getDrawerPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerPage() {
    if (RefDrawerItems.dashBoard == item) {
      return RefDashboard(openDrawer: openDrawer);
    } else if (RefDrawerItems.vehicleStock == item) {
      return VehicleStockScreenRef(openDrawer: openDrawer);
    } else if (RefDrawerItems.invoice == item) {
      return Invoice(openDrawer: openDrawer);
    } else if (RefDrawerItems.cashCollect == item) {
      return DeuInvoiceScreenRef(openDrawer: openDrawer);
    } else if (RefDrawerItems.cashCollectSummary == item) {
      return CashCollectSummaryScreenRef(openDrawer: openDrawer);
    } else if (RefDrawerItems.customerReg == item) {
      return CustomerRegistration(openDrawer: openDrawer);
    } else if (RefDrawerItems.invoiceSummary == item) {
      return InvoiceSummaryScreenRef(openDrawer: openDrawer);
    } else {
      return RefDashboard(openDrawer: openDrawer);
    }
  }
}
