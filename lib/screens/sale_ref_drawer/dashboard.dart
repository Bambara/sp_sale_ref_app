import 'package:flutter/material.dart';

import '../../widgets/drawer_menu_widget.dart';
import '../../widgets/text_button_widget.dart';

class RefDashboard extends StatelessWidget {
  const RefDashboard({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/ref_dashboard';
  final VoidCallback openDrawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: DrawerMenuWidget(
          onClicked: openDrawer,
        ),
        backgroundColor: Colors.transparent,
        title: const Text('Dashboards'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dachboad'),
              Row(
                children: [
                  TextButtonWidget(title: 'Today', function: () {}),
                  TextButtonWidget(title: '7 Days', function: () {}),
                  TextButtonWidget(title: 'This Month', function: () {}),
                  TextButtonWidget(title: 'This Month', function: () {}),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButtonWidget(title: 'Revenue', function: () {}),
              TextButtonWidget(title: 'Sale Return', function: () {}),
              TextButtonWidget(title: 'purchase Return', function: () {}),
              TextButtonWidget(title: 'Profit', function: () {}),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButtonWidget(title: 'Revenue', function: () {}),
              //IconButtonWidget(imagePath: 'assets/images/return.png', function: () {}, isIcon: false, iconData: Icons.label, color: Colors.white)
            ],
          )
        ],
      ),
    );
  }
}
