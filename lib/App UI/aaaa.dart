import 'package:flutter/material.dart';
import 'package:we_chat/components/Screen%20Size.dart';

class AAAAA extends StatefulWidget {
  const AAAAA({super.key});

  @override
  State<AAAAA> createState() => _AAAAAState();
}

class _AAAAAState extends State<AAAAA> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenSize.screenHeight(context),
        width: ScreenSize.screenHeight(context),
        color: Colors.amber,
        child: Center(
          child: Container(
            height: ScreenSize.screenHeight(context) - 400,
            width: ScreenSize.screenHeight(context) - 200,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
