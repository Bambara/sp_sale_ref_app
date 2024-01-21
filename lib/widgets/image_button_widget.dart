import 'package:flutter/material.dart';

class IconButtonWidget extends StatefulWidget {
  const IconButtonWidget(
      {Key? key, required this.imagePath, required this.function, required this.iconData, required this.isIcon, required this.color, required this.iconSize})
      : super(key: key);

  final String imagePath;
  final VoidCallback function;
  final IconData iconData;
  final bool isIcon;
  final Color color;
  final double iconSize;

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: widget.color,
      icon: widget.isIcon
          ? Icon(widget.iconData)
          : Image(
              image: AssetImage(widget.imagePath),
              color: widget.color,
            ),
      onPressed: widget.function,
      iconSize: widget.iconSize,
    );
  }
}
