import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../text/app_text.dart';

class BTN extends StatefulWidget {
  final title;
  final splashColor;
  final double? fontSize;
  final double width;
  final color;
  final fontWeight;
  final textColor;
  final fontFamily;
  final onPressed;

  const BTN({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.width,
    this.splashColor,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textColor,
    this.fontFamily,
  }) : super(key: key);

  @override
  State<BTN> createState() => _BTNState();
}

class _BTNState extends State<BTN> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: MaterialButton(
        onPressed: widget.onPressed,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          // padding: const EdgeInsets.all(20.0),
          child: CustomText(
            title: widget.title,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        splashColor: widget.splashColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}
