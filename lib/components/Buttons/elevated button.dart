import 'package:flutter/material.dart';

class Custome_Elevated_Button extends StatelessWidget {
  // const Custome_Elevated_Button({super.key});
  final String btnName;
  final Icon? icon;
  final Color? bgColor;
  final TextStyle? textStyle;
  final VoidCallback callback;

  Custome_Elevated_Button({
    required this.btnName,
    this.icon,
    this.bgColor = const Color.fromRGBO(0, 0, 0, 1),
    this.textStyle,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        callback();
      },
      child: icon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!,
                SizedBox(
                  width: 8,
                ),
                Text(
                  btnName,
                  style: textStyle,
                )
              ],
            )
          : Text(
              btnName,
              style: textStyle,
            ),
      style: ElevatedButton.styleFrom(
          primary: bgColor,
          shadowColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          )),
    );
  }
}
