import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sp_sale_ref_app/models/vehicle.dart';
import 'package:sp_sale_ref_app/widgets/vehicle_tile_widget.dart';

import '../../widgets/image_button_widget.dart';

class VehicleRegBottomSheetScreen extends StatefulWidget {
  const VehicleRegBottomSheetScreen({Key? key, required this.selectProduct}) : super(key: key);

  final Function(String pCode) selectProduct;

  @override
  _VehicleRegBottomSheetScreenState createState() => _VehicleRegBottomSheetScreenState();
}

class _VehicleRegBottomSheetScreenState extends State<VehicleRegBottomSheetScreen> {
  Future<List<Vehicle>> getVehicles() async =>
      await FirebaseFirestore.instance.collection('vehicles').get().then((value) => value.docs.map((e) => Vehicle.fromJson(e.data())).toList());

  // FirebaseFirestore.instance.collection('vehicles').snapshots().map((snapshot) => snapshot.docs.map((doc) => Vehicle.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.8,
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
                  child: const Center(child: Text('Vehicle List', style: TextStyle(fontSize: 20))),
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
              child: FutureBuilder<List<Vehicle>>(
                future: getVehicles(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.hasData) {
                    final vehicle = snapshot.data!;

                    return ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: vehicle.length,
                      itemBuilder: (context, index) {
                        return VehicleTileWidget(
                          vehicle: vehicle.toList(),
                          index: index,
                          funDelete: () {},
                          funEdit: widget.selectProduct,
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
