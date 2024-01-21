import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget(
      {Key? key, required this.label, required this.isRequired, required this.widthFactor, required this.heightFactor, required this.selectedDate, required this.pickedDate})
      : super(key: key);
  final String label;
  final bool isRequired;
  final num widthFactor;
  final num heightFactor;
  final Function(String value) selectedDate;
  final String pickedDate;

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
        ),
        Container(
          width: MediaQuery.of(context).size.width * widthFactor,
          height: MediaQuery.of(context).size.height * heightFactor,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black54, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                // decoration: const BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: Text(pickedDate),
              ),
              MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.1,
                  child: const Icon(Icons.calendar_today_outlined),
                  onPressed: () {
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year), lastDate: DateTime(2030)).then((pickedDate) {
                      if (pickedDate != null) {
                        selectedDate(DateFormat.yMd().format(pickedDate).toString());
                      }
                    });
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
