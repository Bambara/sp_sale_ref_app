import 'package:flutter/material.dart';

class CheckBoxTileWidget extends StatefulWidget {
  const CheckBoxTileWidget({Key? key, required this.checkStatus, required this.title, required this.widthFactor}) : super(key: key);

  final bool checkStatus;
  final String title;
  final num widthFactor;

  @override
  State<CheckBoxTileWidget> createState() => _CheckBoxTileWidgetState();
}

class _CheckBoxTileWidgetState extends State<CheckBoxTileWidget> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widget.widthFactor,
      alignment: Alignment.center,

      /** CheckboxListTile Widget **/
      child: CheckboxListTile(
        title: Text(widget.title),
        activeColor: Colors.blue,
        checkColor: Colors.white,
        value: _isChecked,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (check) {
          setState(() {
            if (_isChecked == false) {
              _isChecked = true;
            } else {
              _isChecked = false;
            }
          });
        },
      ), //CheckboxListTile
    );
  }
}
