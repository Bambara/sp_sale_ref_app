import 'package:flutter/material.dart';

class FlatButtonWidget extends StatelessWidget {
  const FlatButtonWidget({Key? key, required this.title, required this.function, required this.heightFactor, required this.widthFactor}) : super(key: key);

  final String title;
  final VoidCallback function;
  final num heightFactor;
  final num widthFactor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widthFactor,
      height: MediaQuery.of(context).size.height * heightFactor,
      child: MaterialButton(
        color: const Color.fromRGBO(109, 95, 253, 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        onPressed: () {
          function.call();
          // widget.loadSignup(context);
        },
        child: Center(
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
        ),
      ),
    );
  }
}
