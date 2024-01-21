import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'api/pdf/cash_collect_summary_ref/cash_collect_summary_ref_view.dart';
import 'api/pdf/current_stock_report/cs_view.dart';
import 'api/pdf/deu_summary_admin/deu_summary_admin_view.dart';
import 'api/pdf/grn_report/grn_view.dart';
import 'api/pdf/invoice/invoice_view.dart';
import 'api/pdf/invoice_view/pre_invoice_view.dart';
import 'api/pdf/invoices_summary_ref/invoice_summary_ref_view.dart';
import 'data/app_colors.dart';
import 'screens/admin_drawer/admin_dashboard.dart';
import 'screens/admin_drawer/admin_drawer_screen.dart';
import 'screens/sale_ref_drawer/dashboard.dart';
import 'screens/sale_ref_drawer/ref_drawer_screen.dart';
import 'screens/user/login_screen.dart';
import 'screens/user/signup_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sale Ref App',
      theme: ThemeData(
        primaryColor: AppColors.white,
        dividerTheme: const DividerThemeData(thickness: 1.3, color: Colors.black26, indent: 60),
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        AdminDrawerScreen.routeName: (context) => const AdminDrawerScreen(),
        AdminDashboard.routeName: (context) => AdminDashboard(openDrawer: () {}),
        RefDrawerScreen.routeName: (context) => const RefDrawerScreen(),
        RefDashboard.routeName: (context) => RefDashboard(openDrawer: () {}),
        InvoiceView.routeName: (context) => const InvoiceView(
            allProducts: [],
            invoiceNumber: 0,
            invoiceDate: '',
            customerName: '',
            totalAmount: 0,
            itemCount: 0,
            discountValue: 0,
            discountPra: 0,
            netAmount: 0,
            payedAmount: 0,
            deuAmount: 0,
            returnAmount: 0,
            paymentMethode: ''),
        PreInvoiceView.routeName: (context) => const PreInvoiceView(
            allProducts: [],
            invoiceNumber: 0,
            invoiceDate: '',
            customerName: '',
            refName: '',
            totalAmount: 0,
            itemCount: 0,
            discountValue: 0,
            discountPra: 0,
            netAmount: 0,
            payedAmount: 0,
            deuAmount: 0,
            paymentMethode: ''),
        CurrentStockView.routeName: (context) => const CurrentStockView(vStockItems: [], vehicleNum: ''),
        GRNView.routeName: (context) => const GRNView(vGrnItems: [], vehicleNum: '', loadedDate: '', refName: ''),
        InvoiceSummaryRefView.routeName: (context) => const InvoiceSummaryRefView(
              allInvoices: [],
              refName: '',
              date: '',
              totalInvoices: 0,
              cashInvoices: 0,
              creditInvoices: 0,
              chequeInvoices: 0,
              dailySale: 0,
              dailyCashSale: 0,
              dailyCreditSale: 0,
              dailyChequeSale: 0,
            ),
        CashCollectSummaryRefView.routeName: (context) => const CashCollectSummaryRefView(
              allCollections: [],
              refName: '',
              date: '',
              totalInvoices: 0,
              totalCashCollect: 0,
              totalDeu: 0,
            ),
        DeuSummaryAdminView.routeName: (context) => const DeuSummaryAdminView(
              allInvoices: [],
              refName: '',
              date: '',
            ),
      },
    );
  }
}
