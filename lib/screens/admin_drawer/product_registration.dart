import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:sp_sale_ref_app/models/product.dart';

import '../../widgets/drawer_menu_widget.dart';
import '../../widgets/dropdown_button_widget.dart';
import '../../widgets/form_text_field_widget.dart';
import 'product_register_botom_sheet.dart';

class ProductRegistration extends StatefulWidget {
  const ProductRegistration({Key? key, required this.openDrawer}) : super(key: key);
  static const routeName = '/admin_dashboard';
  final VoidCallback openDrawer;

  @override
  State<ProductRegistration> createState() => _ProductRegistrationState();
}

class _ProductRegistrationState extends State<ProductRegistration> {
  final pCodeCtrl = TextEditingController();
  final bCodeCtrl = TextEditingController();
  final pNameCtrl = TextEditingController();
  final salePriceCtrl = TextEditingController();
  String itemType = 'None';
  String productImageName = '';
  late PlatformFile pImage;

  int imageStatus = 0;

  Future<void> _createProduct() async {
    final product = Product(
      '',
      itemType: itemType,
      productCode: pCodeCtrl.text,
      barCode: bCodeCtrl.text,
      productName: pNameCtrl.text,
      salePrice: double.parse(salePriceCtrl.text),
      productImage: pCodeCtrl.text + '.' + pImage.extension.toString(),
    );

    final customerDoc = FirebaseFirestore.instance.collection('products').doc(product.productCode);

    await customerDoc.set(product.toJson());

    uploadFile(pImage, pCodeCtrl.text);
  }

  void getSelectedItemType(String data) {
    setState(() {
      itemType = data;
    });
  }

  void getProduct(String pCode) async {
    final docEmployee = FirebaseFirestore.instance.collection('products').doc(pCode);
    final snapshot = await docEmployee.get();

    if (snapshot.exists) {
      final product = Product.fromJson(snapshot.data()!);

      pCodeCtrl.text = product.productCode;
      bCodeCtrl.text = product.barCode;
      pNameCtrl.text = product.productName;
      salePriceCtrl.text = product.salePrice.toString();
      setState(() {
        itemType = product.itemType;
        productImageName = product.productImage;
        imageStatus = 2;
        //Logger().i(productImageName);
      });
    }
  }

  void _openProductSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return ProductRegBottomSheetScreen(selectProduct: getProduct);
        });
  }

  Future pickImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final image = result.files.first;
    Logger().i(image.path);
    var imagePath = File(image.path.toString());
    //Logger().i(productImageName);
    setState(() {
      pImage = result.files.first;
      imageStatus = 1;
    });
  }

  Future uploadFile(PlatformFile image, String fileName) async {
    FirebaseStorage.instance.ref('/product_images/' + fileName + '.' + image.extension.toString()).putFile(File(image.path.toString()));
  }

  Future<Widget> loadImage(BuildContext context, String fileName) async {
    Image image = Image.asset('assets/images/hand-sanitizer.png', width: 200, height: 200);
    await FireStorageService.loadImage(context, fileName).then((value) {
      image = Image.network(value.toString(), width: 200, height: 200);
    });
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Product Registration'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FormTextFieldWidget(textController: pCodeCtrl, hintText: 'Product Code', isRequired: true, label: 'Product Code', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormTextFieldWidget(textController: bCodeCtrl, hintText: 'Bar Code', isRequired: true, label: 'Bar Code', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              FormTextFieldWidget(textController: pNameCtrl, hintText: 'Product Name', isRequired: true, label: 'Product Name', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 10),
              DropDownButtonWidget(
                  valveChoose: itemType,
                  items: const ["None", "Packets", "Items", "Bottles"],
                  label: 'Item Type',
                  isRequired: true,
                  selectData: getSelectedItemType,
                  widthFactor: 0.9,
                  heightFactor: 0.05),
              const SizedBox(height: 10),
              FormTextFieldWidget(textController: salePriceCtrl, hintText: 'Sale Price', isRequired: true, label: 'Sale Price', heightFactor: 0.055, widthFactor: 0.9),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => pickImage(),
                child: imageStatus == 1
                    ? Card(
                        elevation: 2,
                        child: Image.file(File(pImage.path.toString()), width: 200, height: 200),
                      )
                    : imageStatus == 2
                        ? FutureBuilder<Widget>(
                            future: loadImage(context, productImageName),
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
              const SizedBox(height: 30),
              //FlatButtonWidget(title: "Add Product", function: _createProduct, heightFactor: 0.07, widthFactor: 0.7),
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
          SpeedDialChild(child: const Icon(FontAwesomeIcons.list), label: 'Product List', onTap: () => _openProductSheet(context)),
          SpeedDialChild(child: const Icon(Icons.save), label: 'Save Product', onTap: () => _createProduct),
        ],
      ),
    );
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();

  static Future<dynamic> loadImage(BuildContext context, String fileName) async {
    return await FirebaseStorage.instance.ref('product_images/').child(fileName).getDownloadURL();
  }
}
