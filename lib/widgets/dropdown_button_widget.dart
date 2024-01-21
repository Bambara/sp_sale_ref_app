import 'package:flutter/material.dart';

class DropDownButtonWidget extends StatelessWidget {
  const DropDownButtonWidget(
      {Key? key,
      required this.items,
      required this.label,
      required this.isRequired,
      required this.selectData,
      required this.widthFactor,
      required this.heightFactor,
      required this.valveChoose})
      : super(key: key);

  final List items;
  final String label;
  final bool isRequired;
  final Function(String value) selectData;
  final num widthFactor;
  final num heightFactor;
  final String valveChoose;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * widthFactor,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 30, bottom: 5, top: 10),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(width: 2),
              isRequired
                  ? const Text(
                      "*",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  : const Text(""),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black54, width: 0.5),
          ),
          width: MediaQuery.of(context).size.width * widthFactor,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: const Text('Select Games'),
              iconSize: 30,
              autofocus: true,
              enableFeedback: true,
              isExpanded: true,
              value: valveChoose,
              items: items.map((valueItem) {
                return DropdownMenuItem(value: valueItem, child: Text(valueItem));
              }).toList(),
              onChanged: (valve) {
                selectData(valve.toString());
              },
            ),
          ),
        ),
      ],
    );
  }
}
