import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:sp_sale_ref_app/models/vehicle.dart';
import 'package:sp_sale_ref_app/screens/admin_drawer/vehicle_register_botom_sheet.dart';
import 'package:sp_sale_ref_app/widgets/image_button_widget.dart';

import '../../widgets/drawer_menu_widget.dart';
import '../../widgets/dropdown_button_widget.dart';
import '../../widgets/form_text_field_widget.dart';

class VehicleRegistration extends StatefulWidget {
  const VehicleRegistration({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/admin_dashboard';
  final VoidCallback openDrawer;

  @override
  State<VehicleRegistration> createState() => _VehicleRegistrationState();
}

class _VehicleRegistrationState extends State<VehicleRegistration> {
  final vNumberCtrl = TextEditingController();
  String vehicleType = 'None';
  String fuelType = 'None';
  String frontImageName = '';
  String backImageName = '';
  late PlatformFile frontImage;
  late PlatformFile backImage;

  int frontImageStatus = 0;
  int backImageStatus = 0;

  Future<void> _createVehicle() async {
    final vehicle = Vehicle(
      vehicleNumber: vNumberCtrl.text,
      vehicleType: vehicleType,
      fuelType: fuelType,
      frontImage: vNumberCtrl.text.toString() + '_Front.' + frontImage.extension.toString(),
      backImage: vNumberCtrl.text.toString() + '_Back.' + backImage.extension.toString(),
    );

    final vehicleDoc = FirebaseFirestore.instance.collection('vehicles').doc(vehicle.vehicleNumber);

    await vehicleDoc.set(vehicle.toJson());

    uploadFrontFile(frontImage, vNumberCtrl.text.toString() + '_Front.' + frontImage.extension.toString());
    uploadBackFile(backImage, vNumberCtrl.text.toString() + '_Back.' + backImage.extension.toString());
  }

  void getSelectedVehicleType(String data) {
    setState(() {
      vehicleType = data;
    });
  }

  void getSelectedFuelType(String data) {
    setState(() {
      fuelType = data;
    });
  }

  void getVehicle(String vehicleNumber) async {
    final docVehicle = FirebaseFirestore.instance.collection('vehicles').doc(vehicleNumber);
    final snapshot = await docVehicle.get();

    if (snapshot.exists) {
      final vehicle = Vehicle.fromJson(snapshot.data()!);
      //Logger().i(vehicle.vehicleNumber);

      vNumberCtrl.text = vehicle.vehicleNumber;
      setState(() {
        vehicleType = vehicle.vehicleType;
        fuelType = vehicle.fuelType;

        frontImageName = vehicle.frontImage;
        backImageName = vehicle.backImage;
        frontImageStatus = 2;
        backImageStatus = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
        /*actions: [
          GestureDetector(
            onTap: () => _openVehicleSheet(context),
            child: const Icon(
              Icons.table_view,
              size: 48,
            ),
          ),
          const SizedBox(width: 20),
        ],*/
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Vehicle Registration'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormTextFieldWidget(textController: vNumberCtrl, hintText: 'Vehicle Number', isRequired: true, label: 'Vehicle Number', heightFactor: 0.055, widthFactor: 0.9),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DropDownButtonWidget(
                    valveChoose: vehicleType,
                    items: const ["None", "Demo Batta", "Tree Wheel", "Bike"],
                    label: 'Vehicle Type',
                    isRequired: true,
                    selectData: getSelectedVehicleType,
                    widthFactor: 0.8,
                    heightFactor: 0.05),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: IconButtonWidget(
                        imagePath: '', function: () => _openVehicleSheet(context), iconData: Icons.add_circle, isIcon: true, color: Colors.black, iconSize: 40))
              ],
            ),
            const SizedBox(height: 10),
            DropDownButtonWidget(
                valveChoose: fuelType,
                items: const ["None", "Disel", "Petrol", "Bottles"],
                label: 'Fuel Type',
                isRequired: true,
                selectData: getSelectedFuelType,
                widthFactor: 0.9,
                heightFactor: 0.05),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: pickFrontImage,
                  child: frontImageStatus == 1
                      ? Card(
                          elevation: 2,
                          child: Image.file(File(frontImage.path.toString()), width: 200, height: 200),
                        )
                      : frontImageStatus == 2
                          ? FutureBuilder<Widget>(
                              future: loadFrontImage(context, frontImageName),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return Card(
                                    elevation: 2,
                                    child: snapshot.data,
                                  );
                                } else if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Card(elevation: 2, child: Image.asset('assets/images/hand-sanitizer.png', width: 200, height: 200));
                                }
                              },
                            )
                          : Card(
                              elevation: 2,
                              child: Image.asset('assets/images/hand-sanitizer.png', width: 200, height: 200),
                            ),
                ),
                GestureDetector(
                  onTap: pickBackImage,
                  child: backImageStatus == 1
                      ? Card(
                          elevation: 2,
                          child: Image.file(File(frontImage.path.toString()), width: 200, height: 200),
                        )
                      : backImageStatus == 2
                          ? FutureBuilder<Widget>(
                              future: loadBackImage(context, backImageName),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return Card(
                                    elevation: 2,
                                    child: snapshot.data,
                                  );
                                } else if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Card(elevation: 2, child: Image.asset('assets/images/hand-sanitizer.png', width: 200, height: 200));
                                }
                              },
                            )
                          : Card(
                              elevation: 2,
                              child: Image.asset('assets/images/hand-sanitizer.png', width: 200, height: 200),
                            ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // FlatButtonWidget(title: "Add Vehicle", function: _createVehicle, heightFactor: 0.07, widthFactor: 0.7),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10,
        children: [
          SpeedDialChild(child: const Icon(FontAwesomeIcons.list), label: 'Vehicle List', onTap: () => _openVehicleSheet(context)),
          SpeedDialChild(child: const Icon(Icons.save), label: 'Save Vehicle', onTap: () => _createVehicle),
        ],
      ),
    );
  }

  void _openVehicleSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        builder: (BuildContext bc) {
          return VehicleRegBottomSheetScreen(selectProduct: getVehicle);
        });
  }

  Future pickFrontImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final image = result.files.first;
    Logger().i(image.path);
    setState(() {
      frontImage = result.files.first;
      frontImageStatus = 1;
    });
  }

  Future pickBackImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final image = result.files.first;
    Logger().i(image.path);
    setState(() {
      backImage = result.files.first;
      backImageStatus = 1;
    });
  }

  Future uploadFrontFile(PlatformFile image, String fileName) async {
    FirebaseStorage.instance.ref('/vehicle_images/' + fileName).putFile(File(image.path.toString()));
  }

  Future uploadBackFile(PlatformFile image, String fileName) async {
    FirebaseStorage.instance.ref('/vehicle_images/' + fileName).putFile(File(image.path.toString()));
  }

  Future<Widget> loadFrontImage(BuildContext context, String fileName) async {
    Image image = Image.asset('assets/images/hand-sanitizer.png', width: 200, height: 200);
    await FireStorageService.loadImage(context, fileName).then((value) {
      image = Image.network(value.toString(), width: 200, height: 200);
    });
    return image;
  }

  Future<Widget> loadBackImage(BuildContext context, String fileName) async {
    Image image = Image.asset('assets/images/hand-sanitizer.png', width: 200, height: 200);
    await FireStorageService.loadImage(context, fileName).then((value) {
      image = Image.network(value.toString(), width: 200, height: 200);
    });
    return image;
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, String fileName) async {
    return await FirebaseStorage.instance.ref('vehicle_images/').child(fileName).getDownloadURL();
  }
}
