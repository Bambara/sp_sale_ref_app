import 'package:flutter/material.dart';

import '../../widgets/flat_button_widget.dart';
import '../../widgets/form_text_field_widget.dart';
import '../../widgets/image_button_widget.dart';

class RouteRegBottomSheetScreen extends StatefulWidget {
  const RouteRegBottomSheetScreen({Key? key}) : super(key: key);

  @override
  _RouteRegBottomSheetScreenState createState() => _RouteRegBottomSheetScreenState();
}

class _RouteRegBottomSheetScreenState extends State<RouteRegBottomSheetScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final routeNameCtrl = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Center(child: Text('Route Register', style: TextStyle(fontSize: 20))),
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
                FormTextFieldWidget(textController: routeNameCtrl, hintText: 'Route Name', isRequired: true, label: 'Route Name', heightFactor: 0.055, widthFactor: 0.9),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 30),
                    FlatButtonWidget(title: "Add Route", function: () {}, heightFactor: 0.07, widthFactor: 0.6),
                    const SizedBox(width: 30),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
