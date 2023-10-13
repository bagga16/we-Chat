import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextEditField extends StatefulWidget {
  final String hintText;
  final errorText;
  final String labelText;
  final double hintSize;
  final double radius;
  final bool isPassword;
  final Color hintcolor;
  final Color textColor;
  final Color cursorColor;
  final TextEditingController textEditingController;
  final TextInputType inputType;
  final preffixIcon;
  final double width;
  final double height;

  final bool readOnly;
  final TextCapitalization textCapitalization;
  final onChanged;
  final onTap;
  final inputFormatters;

  const TextEditField({
    Key? key,
    required this.hintText,
    this.errorText,
    required this.textEditingController,
    this.labelText = "",
    this.isPassword = false,
    this.hintSize = 18,
    this.radius = 8,
    this.hintcolor = Colors.grey,
    this.textColor = Colors.black,
    this.cursorColor = Colors.lightBlue,
    this.inputType = TextInputType.text,
    this.preffixIcon,
    required this.width,
    required this.height,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<TextEditField> createState() => _TextInputFieldViewState();
}

class _TextInputFieldViewState extends State<TextEditField> {
  bool isObscure = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscure = widget.isPassword == true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 46,
      height: 52,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(235, 235, 235, 1),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        onTap: widget.onTap,
        obscureText: isObscure,
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
        style: TextStyle(color: widget.textColor, fontSize: widget.hintSize),
        controller: widget.textEditingController,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          errorText: widget.errorText,
          errorStyle: TextStyle(fontSize: widget.hintSize, color: Colors.red),
          hintStyle: TextStyle(
            color: const Color.fromRGBO(116, 116, 116, 1),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          border: InputBorder.none,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                )
              : SizedBox(),
          prefixIcon: widget.preffixIcon,
        ),
        textCapitalization: widget.textCapitalization,
        cursorColor: widget.cursorColor,
        cursorWidth: 1.5,
      ),
    );
  }
}
