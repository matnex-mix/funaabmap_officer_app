import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funaabmap/utils/globals.dart';
import 'package:go_router/go_router.dart';

import '../utils/assets.dart';
import '../utils/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), (){
      context.go('/login');
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Image.asset(Assets.logo),
              ),
              // width: 200,
              height: 150,
            ),
            const SizedBox(height: 25,),
            DefaultTextStyle(
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: primaryColor),
              textAlign: TextAlign.center,
              child: AnimatedTextKit(
                repeatForever: true,
                pause: Duration.zero,
                animatedTexts: [
                  TypewriterAnimatedText(appTitle, textAlign: TextAlign.center, speed: Duration(milliseconds: 200), cursor: '|'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
