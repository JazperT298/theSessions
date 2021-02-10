import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/VideoconPage/VideoconHelpers.dart';

class Videocon extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: Provider.of<VideoconHelpers>(context, listen: false).appBar(context),
    );
  }
}
