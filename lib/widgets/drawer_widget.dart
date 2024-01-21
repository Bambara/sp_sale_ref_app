import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/data/admin_drawer_items.dart';
import 'package:sp_sale_ref_app/data/login_session.dart';

import '../data/ref_drawer_items.dart';
import '../models/drawer_item.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key, required this.onSelectedItem}) : super(key: key);

  final ValueChanged<DrawerItem> onSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildDrawerItems(context),
          ],
        ),
      ),
    );
  }

  buildDrawerItems(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        children: LoginSession.userType == 'admin'
            ? AdminDrawerItems.all
                .map((item) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      leading: Icon(item.icon, color: Colors.black),
                      title: Text(item.title, style: const TextStyle(color: Colors.black, fontSize: 16)),
                      onTap: () => onSelectedItem(item),
                    ))
                .toList()
            : LoginSession.userType == 'ref'
                ? RefDrawerItems.all
                    .map((item) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          leading: Icon(item.icon, color: Colors.black),
                          title: Text(item.title, style: const TextStyle(color: Colors.black, fontSize: 16)),
                          onTap: () => onSelectedItem(item),
                        ))
                    .toList()
                : RefDrawerItems.all
                    .map((item) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          leading: Icon(item.icon, color: Colors.black),
                          title: Text(item.title, style: const TextStyle(color: Colors.black, fontSize: 16)),
                          onTap: () => onSelectedItem(item),
                        ))
                    .toList(),
      ),
    );
  }
}
