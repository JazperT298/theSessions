import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/LandingPage/landingPage.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  ConstantColors constantColors = ConstantColors();

  @override
  void initState() {
    // TODO: implement initState
    Timer(
      Duration(
        seconds: 1
      ),
        () => Navigator.pushReplacement(context, PageTransition(child: Landingpage(), type: PageTransitionType.leftToRight))
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.whiteColor,
      body: Center(
        child: RichText(
          text: TextSpan(
            text: 'the',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: constantColors.blueColor,
              fontWeight: FontWeight.bold,
              fontSize: 30.0
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Sessions',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constantColors.blueGreyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 34.0),
              )
            ]
          )
        ),
      ),
    );
  }
}
