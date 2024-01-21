import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:sp_sale_ref_app/models/vehicle_stock.dart';

import '../../widgets/flat_button_widget.dart';
import '../../widgets/form_search_text_field_widget.dart';
import '../../widgets/image_button_widget.dart';

class ItemStockUpdateBottomSheet extends StatefulWidget {
  const ItemStockUpdateBottomSheet({Key? key, required this.vehicleStock}) : super(key: key);
  final VehicleStock vehicleStock;

  @override
  _ItemStockUpdateBottomSheetState createState() => _ItemStockUpdateBottomSheetState();
}

class _ItemStockUpdateBottomSheetState extends State<ItemStockUpdateBottomSheet> {
  final SalePriceCtrl = TextEditingController();
  final QtyCtrl = TextEditingController();

  double payedValue = 0, payedPercentage = 0, remainDeu = 0;

  @override
  void initState() {
    SalePriceCtrl.text = widget.vehicleStock.salePrice.toString();
    QtyCtrl.text = widget.vehicleStock.qty.toString();
  }

  void _clearAll() {
    Navigator.of(context).pop();
  }

  Future<void> _updateStock() async {
    String id = widget.vehicleStock.stockId;
    Logger().i(id);

    final updateItemsDoc = FirebaseFirestore.instance.collection('vehicle_stock').doc(id);

    await updateItemsDoc.update({
      'salePrice': double.parse(SalePriceCtrl.text.toString()),
      'qty': int.parse(QtyCtrl.text.toString().split('.')[0]),
    });
  }

  Future<void> _deleteStock() async {
    String id = widget.vehicleStock.stockId;
    Logger().i(id);

    final updateItemsDoc = FirebaseFirestore.instance.collection('vehicle_stock').doc(id);

    await updateItemsDoc.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.37,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: SingleChildScrollView(
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
                    child: const Center(child: Text('Item Update', style: TextStyle(fontSize: 20))),
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Text('Name : ', style: TextStyle(fontSize: 18)),
                      Text(widget.vehicleStock.pName, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      const Text('Code : ', style: TextStyle(fontSize: 18)),
                      Text(widget.vehicleStock.pCode, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FormSearchTextFieldWidget(
                      searchProduct: (String) {},
                      textController: SalePriceCtrl,
                      hintText: 'Sale Price',
                      isRequired: false,
                      label: 'Sale Price',
                      heightFactor: 0.055,
                      widthFactor: 0.4),
                  FormSearchTextFieldWidget(
                    searchProduct: (String) {},
                    textController: QtyCtrl,
                    hintText: 'Quantity',
                    isRequired: false,
                    label: 'Quantity',
                    heightFactor: 0.055,
                    widthFactor: 0.4,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButtonWidget(
                      title: "Update",
                      function: () {
                        _updateStock().whenComplete(
                          () => Navigator.of(context).pop(),
                        );
                      },
                      heightFactor: 0.07,
                      widthFactor: 0.4),
                  FlatButtonWidget(
                      title: "Remove",
                      function: () {
                        _deleteStock().whenComplete(
                          () => Navigator.of(context).pop(),
                        );
                      },
                      heightFactor: 0.07,
                      widthFactor: 0.4),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
