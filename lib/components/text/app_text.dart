import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title;
  final Color color;
  final double fontSize;
  final double letterSpacing;
  final double wordSpacing;
  final FontWeight fontWeight;
  // final String fontFamily;

  const CustomText({
    super.key,
    required this.title,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w600,
    this.letterSpacing = .1,
    this.wordSpacing = .3,
    this.fontSize = 20,
    // this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          fontWeight: fontWeight,
          wordSpacing: wordSpacing),
    );
  }
}
