import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Widget image;
  final Widget text;
  final Color color;
  final double radius;
  final VoidCallback? onPressed;

  const MyButton({
    super.key,
    required this.image,
    required this.text,
    required this.color,
    required this.radius,
    this.onPressed,
  });

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: widget.color),
        onPressed: widget.onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            widget.image,
            widget.text,
            Opacity(opacity: 0.0, child: widget.image),
          ],
        ),
      ),
    );
  }
}
