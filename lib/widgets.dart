import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      "Messages",
      style: TextStyle(fontSize: 15.0),
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    counterText: "",
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    contentPadding: EdgeInsets.only(left: 10, right: 10),
    hintText: hintText,
    errorStyle: TextStyle(fontSize: 9, height: 0.3),
  );
}

EdgeInsets padingEdge() {
  return EdgeInsets.only(left: 8.0, right: 8.0);
}

BoxDecoration commonBoxdecoration() {
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        blurRadius: 1.1,
        color: Colors.grey,
        spreadRadius: 0.5,
        offset: Offset(
          1.5,
          2,
        ),
      ),
    ],
    borderRadius: BorderRadius.circular(30.0),
  );
}

TextStyle mediumStyle() {
  return TextStyle(
    fontFamily: "SourceSansPro",
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
  );
}
TextStyle boldStyle() {
  return TextStyle(
    fontFamily: "SourceSansPro",
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
  );
}
