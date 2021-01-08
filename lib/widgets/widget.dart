import 'package:flutter/material.dart';

Widget appbar(BuildContext context) {
  return AppBar(
    title: Text('InstaChat'),
  );
}

InputDecoration textfieldinputdecoration(String hinttext) {
  return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      hintText: hinttext,
      hintStyle: TextStyle(color: Colors.white));
}

TextStyle textfieldstyle(){
  return TextStyle(color: Colors.white);
}