import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/drawer_item.dart';

class AdminDrawerItems {
  static final DrawerItem dashBoard = DrawerItem('Dashboard', Icons.dashboard_rounded);
  static final DrawerItem customerReg = DrawerItem('Customer Registration', FontAwesomeIcons.users);
  static final DrawerItem employeeReg = DrawerItem('Employee Registration', FontAwesomeIcons.userGear);
  static final DrawerItem productReg = DrawerItem('Product Registration', Icons.account_tree);
  static final DrawerItem vehicleReg = DrawerItem('Vehicle Registration', Icons.airport_shuttle);
  static final DrawerItem vehicleLoad = DrawerItem('Vehicle Load', Icons.add_shopping_cart);
  static final DrawerItem vehicleStock = DrawerItem('Vehicle Stock', Icons.add_chart);
  static final DrawerItem deuInvoice = DrawerItem('Invoice Deu', Icons.map);
  static final DrawerItem cashCollectSummary = DrawerItem('Cash Collect Summary', Icons.collections);
  static final DrawerItem invoiceSummary = DrawerItem('Invoice Summary', FontAwesomeIcons.chartArea);
  static final DrawerItem invoice = DrawerItem('Invoice', FontAwesomeIcons.receipt);

  static final List<DrawerItem> all = [
    dashBoard,
    vehicleLoad,
    vehicleStock,
    invoice,
    invoiceSummary,
    deuInvoice,
    cashCollectSummary,
    customerReg,
    employeeReg,
    productReg,
    vehicleReg
  ];
}
