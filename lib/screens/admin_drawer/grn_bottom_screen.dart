import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../api/pdf/grn_report/grn_view.dart';
import '../../models/loaded_products.dart';
import '../../widgets/date_picker_widget.dart';
import '../../widgets/image_button_widget.dart';
import '../../widgets/load_items_tile_widget.dart';

class GrnBottomSheet extends StatefulWidget {
  const GrnBottomSheet({Key? key, required this.vehicleNumber}) : super(key: key);
  final String vehicleNumber;

  @override
  _GrnBottomSheetState createState() => _GrnBottomSheetState();
}

class _GrnBottomSheetState extends State<GrnBottomSheet> {
  var selectedDate = DateFormat.yMd().format(DateTime.now()).toString();
  late List<LoadedProducts> allProducts;
  var customerName, refName;
  var setDefaultMakeRef = true, setDefaultMakeModelRef = true;

  double payedValue = 0, payedPercentage = 0, remainDeu = 0;

  Future<List<LoadedProducts>> _getGRNItems() async {
    selectedDate = selectedDate.replaceAll('/', '-');
    Logger().i(widget.vehicleNumber + '_' + refName.toString().characters.first.toUpperCase() + refName.toString().substring(1) + '_' + selectedDate);
    return await FirebaseFirestore.instance
        .collection('vehicle_loaded_items')
        .where('loadId', isEqualTo: widget.vehicleNumber + '_' + refName.toString() + '_' + selectedDate)
        .get()
        .then((value) => value.docs.map((e) => LoadedProducts.fromJson(e.data())).toList());
    // .map((snapshot) => snapshot.docs.map((doc) => LoadedProducts.fromJson(doc.data())).toList());
  }

  @override
  void initState() {}

  void _clearAll() {
    Navigator.of(context).pop();
  }

  void _getSelectedDate(String date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _openGRNView() {
    Navigator.of(context).pushNamed(
      GRNView.routeName,
      arguments: GRNView(
        vGrnItems: allProducts,
        vehicleNum: widget.vehicleNumber,
        loadedDate: selectedDate,
        refName: refName,
      ),
    );
    Logger().i('Ok');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Center(child: Text('Product List', style: TextStyle(fontSize: 20))),
                ),
                IconButtonWidget(imagePath: '', function: _openGRNView, iconData: Icons.print, isIcon: true, iconSize: 32, color: Colors.black),
                SizedBox(width: 20),
              ],
            ),
            DatePickerWidget(label: 'Date', isRequired: true, widthFactor: 0.9, heightFactor: 0.05, selectedDate: _getSelectedDate, pickedDate: selectedDate),
            const SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 30, bottom: 5, top: 10),
              child: Row(
                children: const [
                  Text(
                    'Ref Name',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(width: 2),
                  true
                      ? Text(
                          "*",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        )
                      : Text(""),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.black54, width: 0.5),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('users').get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Safety check to ensure that snapshot contains data
                  // without this safety check, StreamBuilder dirty state warnings will be thrown
                  if (!snapshot.hasData) return Container();
                  // Set this value for default,
                  // setDefault will change if an item was selected
                  // First item from the List will be displayed
                  if (setDefaultMakeRef) {
                    refName = snapshot.data?.docs[0].get('user_name');
                    debugPrint('setDefault make: $refName');
                  }
                  return DropdownButton(
                    autofocus: true,
                    enableFeedback: true,
                    isExpanded: true,
                    value: refName,
                    items: snapshot.data?.docs.map((value) {
                      return DropdownMenuItem(
                        value: value.get('user_name'),
                        child: Text('${value.get('user_name')}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      //debugPrint('selected onchange: $value');
                      //getInvoicesByRefName(value.toString());
                      //calDailyIncome();
                      setState(
                        () {
                          //calDailyIncome();
                          //customerName = value.toString();
                          //debugPrint('make selected: $value');
                          // Selected value will be stored
                          refName = value;
                          // Default dropdown value won't be displayed anymore
                          setDefaultMakeRef = false;
                          // Set makeModel to true to display first car from list
                          setDefaultMakeModelRef = true;
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: FutureBuilder<List<LoadedProducts>>(
                future: _getGRNItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('No Products Found'));
                  } else if (snapshot.hasData) {
                    allProducts = snapshot.data!;

                    return ListView.builder(
                      addAutomaticKeepAlives: false,
                      cacheExtent: 100,
                      itemCount: allProducts.length,
                      itemBuilder: (context, index) {
                        return LoadItemsTileWidget(
                          product: allProducts.toList(),
                          index: index,
                          //viewUpdateSheet: (){},
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
