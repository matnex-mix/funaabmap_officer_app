import 'package:flutter/material.dart';

Color primaryColor = Colors.green;
Color backgroundColor = Colors.white;
Color whiteColor = Color(0xFFF2F2F2);
Color redColor = Colors.red;

ButtonStyle primaryButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(primaryColor),
  fixedSize: MaterialStateProperty.all(Size(double.infinity, 50)),
  minimumSize: MaterialStateProperty.all(Size(150, 0)),
  foregroundColor: MaterialStateProperty.all(whiteColor)
);
