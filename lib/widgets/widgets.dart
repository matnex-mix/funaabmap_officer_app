import 'package:flutter/material.dart';
import 'package:funaabmap/utils/routes.dart';
import 'package:funaabmap/utils/theme.dart';

class Widgets {
  static Widget load({bool dismissible = false}){
    return PopScope(
      canPop: dismissible,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              child: Container(
                color: Colors.black.withOpacity(.5),
              ),
              onTap: dismissible ? () => router.pop() : null,
            ),
            Center(
              child: Container(
                height: 45,
                width: 45,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CircularProgressIndicator(color: primaryColor, strokeWidth: 3),
              ),
            ),
          ]
        ),
      ),
    );
  }
}