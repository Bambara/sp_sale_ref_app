import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/drawer_item.dart';

class RefDrawerItems {
  static final DrawerItem dashBoard = DrawerItem('Dashboard', Icons.dashboard_rounded);
  static final DrawerItem vehicleStock = DrawerItem('Vehicle Stock', Icons.add_box_rounded);
  static final DrawerItem invoice = DrawerItem('Invoice', Icons.account_balance_wallet);
  static final DrawerItem cashCollect = DrawerItem('Cash Collect', Icons.money_sharp);
  static final DrawerItem cashCollectSummary = DrawerItem('Cash Collect Summary', Icons.monetization_on_outlined);
  static final DrawerItem customerReg = DrawerItem('Customer Registration', FontAwesomeIcons.users);
  static final DrawerItem invoiceSummary = DrawerItem('Invoice Summary', FontAwesomeIcons.chartArea);

  static final List<DrawerItem> all = [dashBoard, vehicleStock, invoice, invoiceSummary, cashCollect, cashCollectSummary, customerReg];
}
