import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../data/login_session.dart';
import '../../models/deu_invoice_pay.dart';
import '../../widgets/flat_button_widget.dart';
import '../../widgets/form_search_text_field_widget.dart';
import '../../widgets/image_button_widget.dart';

class InvoiceDeuPayBottomSheet extends StatefulWidget {
  const InvoiceDeuPayBottomSheet({Key? key, required this.invoiceId, required this.customerName, required this.deuAmount}) : super(key: key);
  final String invoiceId;
  final String customerName;
  final double deuAmount;

  @override
  _InvoiceDeuPayBottomSheetState createState() => _InvoiceDeuPayBottomSheetState();
}

class _InvoiceDeuPayBottomSheetState extends State<InvoiceDeuPayBottomSheet> {
  final payedPercentageCtrl = TextEditingController();
  final payedAmountCtrl = TextEditingController();

  double payedValue = 0, payedPercentage = 0, remainDeu = 0;

  @override
  void initState() {
    super.initState();
    _calRemainAmount();
  }

  void _clearAll() {
    Navigator.of(context).pop();
  }

  void _calPayedPercentage(String value) {
    if (payedAmountCtrl.text == '' || payedAmountCtrl.text.isEmpty) {
      setState(() {
        payedAmountCtrl.text = '0';
      });
    } else {
      payedValue = double.parse(value);
      payedPercentage = ((payedValue / (widget.deuAmount)) * 100.00);
      payedPercentage = double.parse(payedPercentage.toStringAsPrecision(2));
      setState(() {
        payedPercentageCtrl.text = payedPercentage.toString();
        remainDeu = (widget.deuAmount - payedValue);
      });
    }
  }

  void _calPayedValue(String value) {
    if (payedPercentageCtrl.text == '' || payedPercentageCtrl.text.isEmpty) {
      setState(() {
        payedPercentageCtrl.text = '0';
      });
    } else {
      payedPercentage = double.parse(value);
      payedValue = ((payedPercentage * widget.deuAmount) / 100.00);
      payedValue = double.parse(payedValue.toStringAsPrecision(2));
      setState(() {
        payedAmountCtrl.text = payedValue.toString();
        remainDeu = (widget.deuAmount - payedValue);
      });
    }
  }

  void _calRemainAmount() {
    setState(() {
      remainDeu = (widget.deuAmount - payedValue);
    });
  }

  Future<void> _pay() async {
    try {
      double payedAmount = double.parse(payedAmountCtrl.text);
      double due = (widget.deuAmount - payedAmount);
      late final updateItemsDoc;
      /*if (int.parse(widget.invoiceId) > 0 && LoginSession.refName.contains('nilantha')) {
        updateItemsDoc = FirebaseFirestore.instance.collection('deu_invoice').doc(widget.invoiceId + '_' + LoginSession.refName);
      } else if (int.parse(widget.invoiceId) > 340 && LoginSession.refName.contains('shan')) {
        updateItemsDoc = FirebaseFirestore.instance.collection('deu_invoice').doc(widget.invoiceId + '_' + LoginSession.refName);
      } else if (int.parse(widget.invoiceId) > 340 && LoginSession.refName.contains('isuru')) {
        updateItemsDoc = FirebaseFirestore.instance.collection('deu_invoice').doc(widget.invoiceId + '_' + LoginSession.refName);
      } else {
        //Logger().i(widget.invoiceId);
        updateItemsDoc = FirebaseFirestore.instance.collection('deu_invoice').doc(widget.invoiceId);
      }*/

      updateItemsDoc = FirebaseFirestore.instance.collection('deu_invoice').doc(widget.invoiceId + '_' + LoginSession.refName);

      await updateItemsDoc.update({'deuAmount': due});
    } catch (e) {}
  }

  String _genDate() {
    String date = DateFormat.yMd().format(DateTime.now()).toString();
    date = date.replaceAll('/', '-');
    return date;
  }

  Future<void> _savePayments() async {
    try {
      final invoice = DeuInvoicePay(
          id: widget.invoiceId + '_' + LoginSession.refName + '_' + DateFormat.yMd().format(DateTime.now()).toString(),
          invoiceId: widget.invoiceId + '_' + LoginSession.refName,
          customerName: widget.customerName,
          payedDate: DateFormat.yMd().format(DateTime.now()).toString(),
          payedAmount: payedValue,
          deuAmount: remainDeu,
          refName: LoginSession.refName);

      final deuPayDoc = FirebaseFirestore.instance.collection('deu_invoice_pay').doc(widget.invoiceId + '_' + LoginSession.refName + '_' + _genDate());

      await deuPayDoc.set(invoice.toJson());
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.43,
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
                    child: const Center(child: Text('Invoice Deu Pay', style: TextStyle(fontSize: 20))),
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
                      const Text('Invoice Number : ', style: TextStyle(fontSize: 18)),
                      Text(widget.invoiceId, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      const Text('Due Amount : ', style: TextStyle(fontSize: 18)),
                      Text(widget.deuAmount.toString(), style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FormSearchTextFieldWidget(
                      searchProduct: _calPayedPercentage,
                      textController: payedAmountCtrl,
                      hintText: 'Payed Value',
                      isRequired: false,
                      label: 'Payed Value',
                      heightFactor: 0.055,
                      widthFactor: 0.4),
                  FormSearchTextFieldWidget(
                      searchProduct: _calPayedValue,
                      textController: payedPercentageCtrl,
                      hintText: 'Payed %',
                      isRequired: false,
                      label: 'Payed %',
                      heightFactor: 0.055,
                      widthFactor: 0.4),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Remain Deu : ', style: TextStyle(fontSize: 18)),
                  Text(remainDeu.toString(), style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButtonWidget(
                      title: "Pay",
                      function: () {
                        _pay().whenComplete(() {
                          _savePayments().whenComplete(() {
                            Fluttertoast.showToast(
                                msg: "Deu Pay Done !",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context).pop();
                          });
                        }).onError(
                          (error, stackTrace) => Fluttertoast.showToast(
                              msg: "Deu Pay Fail !",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0),
                        );
                      },
                      heightFactor: 0.07,
                      widthFactor: 0.4),
                  FlatButtonWidget(title: "Clear", function: _clearAll, heightFactor: 0.07, widthFactor: 0.4),
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
