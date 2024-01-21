import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../api/pdf/invoice_service.dart';
import '../../api/pdf/product.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  static const routeName = '/sign_up_screen';

  @override
  Widget build(BuildContext context) {
    final fNameCtrl = TextEditingController();
    final lNameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    List<Product> products = [
      Product("Membership", 9.99, 19),
      Product("Nails", 0.30, 19),
      Product("Hammer", 26.43, 19),
      Product("Hamburger", 5.99, 7),
    ];
    int number = 0;

    return Scaffold(
      /* body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/user_circle_x4.png'),
            const Text('Create New Account', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 40),
            FormTextFieldWidget(textController: fNameCtrl, hintText: 'Full Name', isRequired: true, label: 'Full Name', heightFactor: 0.055, widthFactor: 0.9),
            const SizedBox(height: 10),
            FormTextFieldWidget(
                textController: lNameCtrl, hintText: 'Email / Phone Number', isRequired: true, label: 'Email / Phone Number', heightFactor: 0.055, widthFactor: 0.9),
            const SizedBox(height: 10),
            FormTextFieldWidget(textController: passwordCtrl, hintText: 'Password', isRequired: true, label: 'Password', heightFactor: 0.055, widthFactor: 0.9),
            const SizedBox(height: 40),
            FlatButtonWidget(title: "Create Account", function: () {}, heightFactor: 0.07, widthFactor: 0.7),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      //FirebaseFirestore.instance;
                    },
                    child: const Text('Sign In', style: TextStyle(fontSize: 16, color: Colors.blue))),
              ],
            ),
          ],
        ),
      ),*/
      body: PdfPreview(
        pageFormats: const {'pageFormat': PdfPageFormat(57, 80)},
        build: (pageFormat) {
          return PdfInvoiceService().createInvoice(products);
        },
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: 200,
                height: 200,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
