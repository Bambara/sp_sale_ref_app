import 'package:flutter/material.dart';

class FormNumberFieldWidget extends StatelessWidget {
  const FormNumberFieldWidget(
      {Key? key,
      required this.hintText,
      required this.label,
      required this.isRequired,
      required this.widthFactor,
      required this.heightFactor,
      required this.textController,
      required this.action})
      : super(key: key);

  final String hintText;
  final String label;
  final bool isRequired;
  final num widthFactor;
  final num heightFactor;
  final TextEditingController textController;
  final Function(String value) action;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*Container(
          width: MediaQuery.of(context).size.width * widthFactor,
          alignment: Alignment.centerLeft,
          // margin: const EdgeInsets.only(left: 30, bottom: 5, top: 10),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(width: 2),
              isRequired
                  ? const Text(
                      "*",
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    )
                  : const Text(""),
            ],
          ),
        ),*/
        Container(
          width: MediaQuery.of(context).size.width * widthFactor,
          height: MediaQuery.of(context).size.height * heightFactor,
          /* padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black54, width: 0.5),
          ),*/
          child: TextField(
            onChanged: (value) {
              action(value);
            },
            textInputAction: TextInputAction.next,
            controller: textController,
            obscureText: false,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                //hintText: hintText,
                labelText: hintText,
                labelStyle: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
