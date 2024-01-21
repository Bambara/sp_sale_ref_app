import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/pdf/invoice/invoice_view.dart';
import '../../data/invoice_data.dart';
import '../../data/login_session.dart';
import '../../models/customer.dart';
import '../../models/invoice_deu.dart';
import '../../models/invoice_items.dart';
import '../../models/invoices.dart';
import '../../widgets/dropdown_button_widget.dart';
import '../../widgets/flat_button_widget.dart';
import '../../widgets/form_number_field_widget.dart';
import '../../widgets/image_button_widget.dart';

class InvoiceFinishBottomSheetScreen extends StatefulWidget {
  const InvoiceFinishBottomSheetScreen(
      {Key? key,
      required this.totalAmount,
      required this.itemCount,
      required this.customerName,
      required this.allProducts,
      required this.removeAllProduct,
      required this.invoiceNumber,
      required this.discountValue})
      : super(key: key);

  final double totalAmount;
  final double discountValue;
  final double itemCount;
  final String customerName;
  final int invoiceNumber;
  final List<InvoiceItems> allProducts;
  final VoidCallback removeAllProduct;

  @override
  _InvoiceFinishBottomSheetScreenState createState() => _InvoiceFinishBottomSheetScreenState();
}

class _InvoiceFinishBottomSheetScreenState extends State<InvoiceFinishBottomSheetScreen> {
  //late List<Product> allProducts;
  late List<Customer> allCustomers;
  String paymentMethode = 'Cash';
  String invoiceDate = '';
  double discountValue = 0, discountPra = 0, netAmount = 0, payedAmount = 0, deuAmount = 0, returnAmount = 0;

  //int invoiceNumber = 0;

  final disValueCtrl = TextEditingController();
  final disPercentageCtrl = TextEditingController();
  final payedAmountCtrl = TextEditingController();
  final deuAmountCtrl = TextEditingController();
  final returnAmountCtrl = TextEditingController();

  @override
  void initState() {
    //disValueCtrl.text = '0';
    //returnAmountCtrl.text = '0';
    _calDisPercentage('0');
    _calNetAmount();
    /* discountValue = widget.discountValue;
    _calDisPercentage('0');*/
  }

  void clearAll() {
    paymentMethode = 'Cash';
    invoiceDate = '';
    discountValue = 0;
    discountPra = 0;
    netAmount = 0;
    payedAmount = 0;
    deuAmount = 0;
    widget.removeAllProduct.call();
    Navigator.of(context).pop();
  }

  /*Future<int> _genLastInvoiceId() async {
    int invoiceId = 0;
    try {
      var variable = await FirebaseFirestore.instance.collection('invoice').where('id', isGreaterThan: 0).orderBy('id').get();
      invoiceId = int.parse(variable.docs.last.data()['id'].toString());
      loadInvoiceNumber(invoiceId);
      //Logger().i('Invoice ID');
      //Logger().i(variable.docs.last.data()['id'].toString());
      //qty = double.parse(variable.data()!['qty'].toString());
    } catch (e) {
      invoiceId = 0;
      loadInvoiceNumber(invoiceId);
    }
    return invoiceId;
  }

  void loadInvoiceNumber(int liNumber) {
    setState(() {
      InvoiceData.preInvoiceNumber = invoiceNumber;
      invoiceNumber = (liNumber + 1);
    });
    //Logger().i(invoiceNumber);
  }*/

  Future<List<Customer>> getCustomers() async {
    // return FirebaseFirestore.instance.collection('customers').snapshots().map((snapshot) => snapshot.docs.map((doc) => Customer.fromJson(doc.data())).toList());
    return await FirebaseFirestore.instance.collection('customers').get().then((value) => value.docs.map((e) => Customer.fromJson(e.data())).toList());
  }

  void _getCus() {
    var customers = getCustomers();
  }

  void _calNetAmount() {
    setState(() {
      netAmount = (widget.totalAmount - widget.discountValue);
    });
  }

  void _getSelectedVehicleNum(String data) {
    setState(() {
      paymentMethode = data;
    });
  }

  void _calDisPercentage(String value) {
    if (disValueCtrl.text == '' || disValueCtrl.text.isEmpty) {
      setState(() {
        //Logger().i('0');
        discountValue = 0;
        /* discountValue = widget.discountValue;
        discountPra = ((widget.discountValue / widget.totalAmount) * 100.00);
        discountPra = double.parse(discountPra.toStringAsPrecision(2));*/
      });
    } else {
      discountValue = double.parse(disValueCtrl.text);
      discountPra = ((discountValue / (widget.totalAmount - widget.discountValue)) * 100.00);
      discountPra = double.parse(discountPra.toStringAsPrecision(2));
      //discountValue += widget.discountValue;
      setState(() {
        disPercentageCtrl.text = discountPra.toString();
        netAmount = (widget.totalAmount - (discountValue + widget.discountValue));
      });
    }
  }

  void _calDisValue(String value) {
    if (disPercentageCtrl.text == '' || disPercentageCtrl.text.isEmpty) {
      setState(() {
        //Logger().i('0');
        discountPra = 0;
        /*discountValue = widget.discountValue;
        discountPra = ((widget.discountValue / widget.totalAmount) * 100.00);
        discountPra = double.parse(discountPra.toStringAsPrecision(2));*/
      });
    } else {
      discountPra = double.parse(value);
      discountValue = ((discountPra * (widget.totalAmount - widget.discountValue)) / 100.00);
      discountValue = double.parse(discountValue.toString());
      //discountValue += widget.discountValue;
      setState(() {
        disValueCtrl.text = discountValue.toString();
        netAmount = (widget.totalAmount - (discountValue + widget.discountValue));
      });
    }
  }

  void _addReturnAmount(String value) {
    if (returnAmountCtrl.text.isEmpty) {
      //returnAmountCtrl.text = '0';
    } else {
      /*returnAmount = double.parse(returnAmountCtrl.text);
      returnAmount = (netAmount - returnAmount);*/
    }
  }

  void _calDeuAmount(String value) {
    if (payedAmountCtrl.text.isEmpty) {
      payedAmount = 0;
    } else {
      payedAmount = double.parse(payedAmountCtrl.text);
    }

    if (returnAmountCtrl.text.isEmpty) {
      returnAmount = 0;
    } else {
      returnAmount = double.parse(returnAmountCtrl.text);
    }

    setState(() {
      deuAmount = (netAmount - (payedAmount + returnAmount));
      deuAmountCtrl.text = deuAmount.toString();
      if (deuAmount > 0) {
        paymentMethode = 'Credit';
      } else {
        paymentMethode = 'Cash';
      }
    });
  }

  String _genDate() {
    String date = DateFormat.yMd().format(DateTime.now()).toString();
    date = date.replaceAll('/', '-');
    return invoiceDate = date;
  }

  void _saveInvoices() {
    var dialogContext;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              child: Container(
                padding: EdgeInsets.all(10),
                width: 20,
                height: 170,
                child: Column(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Please Wait ! Invoice Printing.....'),
                  ],
                ),
              ));
        });

    /* if (invoiceNumber == 0) {
      _genLastInvoiceId();
      //_genLastInvoiceId();
    }*/

    /*_genLastInvoiceId().whenComplete(() {
      if (invoiceNumber > 0 && invoiceNumber > InvoiceData.preInvoiceNumber) {

      }
    });*/

    _saveInvoice().whenComplete(
      () => _saveInvoiceItems().whenComplete(
        () => _updateStock().whenComplete(
          () {
            /* double disValue, disPre;
            disValue = widget.discountValue + discountValue;
            disPre = ((disValue / widget.totalAmount) * 100.00);
            disPre = double.parse(disPre.toStringAsPrecision(2));*/
            //Pop Dismiss

            InvoiceData.preInvoiceNumber = widget.invoiceNumber;

            Navigator.pop(dialogContext);

            //Pop Invoice Print
            Navigator.of(context).pushNamed(
              InvoiceView.routeName,
              arguments: InvoiceView(
                allProducts: widget.allProducts,
                invoiceNumber: widget.invoiceNumber,
                invoiceDate: DateFormat.yMd().format(DateTime.now()).toString(),
                customerName: widget.customerName,
                itemCount: widget.itemCount,
                totalAmount: widget.totalAmount,
                deuAmount: deuAmount,
                discountPra: discountPra,
                discountValue: discountValue,
                netAmount: netAmount,
                payedAmount: payedAmount,
                returnAmount: returnAmount,
                paymentMethode: paymentMethode,
              ),
            );
            discountValue = 0;
            if (deuAmount > 0) {
              _saveDeuInvoice();
            }
          },
        ),
      ),
    );
  }

  Future<void> _saveInvoice() async {
    if (disValueCtrl.text == '') {
      discountValue = 0;
    } else if (disValueCtrl.text != '0') {
      discountValue = double.parse(disValueCtrl.text.toString());
    }

    setState(() {
      discountValue += widget.discountValue;
      discountPra = ((discountValue / widget.totalAmount) * 100.00);
      discountPra = double.parse(discountPra.toStringAsPrecision(2));
    });

    final invoice = Invoices(
        id: widget.invoiceNumber,
        date: DateFormat.yMd().format(DateTime.now()).toString(),
        customerName: widget.customerName,
        refName: LoginSession.refName,
        vehicleNum: LoginSession.vehicleNum,
        itemCount: widget.itemCount,
        totalAmount: widget.totalAmount,
        disValue: discountValue,
        disPrace: discountPra,
        netAmount: netAmount,
        pMethode: paymentMethode,
        pAmount: payedAmount,
        deuAmount: deuAmount);

    String invoiceNum = widget.invoiceNumber.toString() + '_' + LoginSession.refName;

    final vehicleLoadDoc = FirebaseFirestore.instance.collection('invoice').doc(invoiceNum);

    await vehicleLoadDoc.set(invoice.toJson());
  }

  Future<void> _saveInvoiceItems() async {
    var batch = FirebaseFirestore.instance.batch();

    for (var invoice in widget.allProducts) {
      //Logger().i(element.productName);
      //invoice.invoiceId = invoiceNumber;
      final loadedItemsDoc =
          FirebaseFirestore.instance.collection('invoice_items').doc(widget.invoiceNumber.toString() + '_' + LoginSession.refName + '_' + invoice.productCode);
      // invoice.invoiceId = widget.invoiceNumber.toString() + '_' + LoginSession.refName;
      batch.set(loadedItemsDoc, invoice.toJson());
      // double newQty = (element.aveQty - element.qty);
      // updateStock(LoginSession.vehicleNum, element.productCode, element.salePrice, newQty);
    }
    await batch.commit();
  }

  Future<void> _updateStock() async {
    for (var invoice in widget.allProducts) {
      double newQty = (invoice.aveQty - invoice.qty);
      String id = LoginSession.vehicleNum + '_' + invoice.productCode + '_' + invoice.salePrice.toString();
      final updateItemsDoc = FirebaseFirestore.instance.collection('vehicle_stock').doc(id);
      // Logger().i(id);
      await updateItemsDoc.update({'qty': newQty});
    }
  }

  Future<void> _saveDeuInvoice() async {
    final deuInvoice = InvoiceDeu(
        id: widget.invoiceNumber.toString(),
        date: DateFormat.yMd().format(DateTime.now()).toString(),
        invoiceNumber: widget.invoiceNumber,
        customerName: widget.customerName,
        refName: LoginSession.refName,
        deuAmount: deuAmount,
        status: 'Deu');
    final deuInvoiceDoc = FirebaseFirestore.instance.collection('deu_invoice').doc(widget.invoiceNumber.toString() + '_' + LoginSession.refName);

    await deuInvoiceDoc.set(deuInvoice.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height * 0.76,
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
                    child: const Center(child: Text('Invoice Pay', style: TextStyle(fontSize: 20))),
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
                      const Text('Item Count : ', style: TextStyle(fontSize: 18)),
                      Text(widget.itemCount.toString(), style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      const Text('Gross Amount : ', style: TextStyle(fontSize: 18)),
                      Text(widget.totalAmount.toString(), style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Line Dis. Amount : ', style: TextStyle(fontSize: 18)),
                  Text(widget.discountValue.toString(), style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FormNumberFieldWidget(
                      action: _calDisPercentage,
                      textController: disValueCtrl,
                      hintText: 'Discount Value',
                      isRequired: false,
                      label: 'Discount Value',
                      heightFactor: 0.055,
                      widthFactor: 0.4),
                  FormNumberFieldWidget(
                      action: _calDisValue,
                      textController: disPercentageCtrl,
                      hintText: 'Discount %',
                      isRequired: false,
                      label: 'Discount %',
                      heightFactor: 0.055,
                      widthFactor: 0.4),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Net Amount : ', style: TextStyle(fontSize: 18)),
                  Text(netAmount.toString(), style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              FormNumberFieldWidget(
                  action: _addReturnAmount,
                  textController: returnAmountCtrl,
                  hintText: 'Payed Amount',
                  isRequired: true,
                  label: 'Payed Amount',
                  heightFactor: 0.055,
                  widthFactor: 0.9),
              const SizedBox(height: 20),
              DropDownButtonWidget(
                  valveChoose: paymentMethode,
                  items: const ["Cash", "Cheque", "Credit"],
                  label: 'Payment Methode',
                  isRequired: true,
                  selectData: _getSelectedVehicleNum,
                  widthFactor: 0.9,
                  heightFactor: 0.05),
              const SizedBox(height: 10),
              FormNumberFieldWidget(
                  action: _calDeuAmount,
                  textController: payedAmountCtrl,
                  hintText: 'Payed Amount',
                  isRequired: true,
                  label: 'Payed Amount',
                  heightFactor: 0.055,
                  widthFactor: 0.9),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Deu Amount : ', style: TextStyle(fontSize: 18)),
                  Text(deuAmount.toString(), style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButtonWidget(title: "Pay", function: _saveInvoices, heightFactor: 0.07, widthFactor: 0.4),
                  FlatButtonWidget(title: "Clear", function: clearAll, heightFactor: 0.07, widthFactor: 0.4),
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
