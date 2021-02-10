import 'package:flutter/material.dart';
import 'package:the_sessions/constants/Constantcolors.dart';

class RewardsHelper with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.darkColor.withOpacity(0.6),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert_outlined,
            color: constantColors.greenColor,
          ),
          onPressed: () {
          },
        ),
      ],
      title: RichText(
        text: TextSpan(
            text: 'My ',
            style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            children: <TextSpan>[
              TextSpan(
                text: 'Rewards',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              )
            ]),
      ),
    );
  }
}