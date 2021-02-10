import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

class HomepageHelpers with ChangeNotifier{
  ConstantColors constantColors = ConstantColors();

  Widget bottomNavBar(BuildContext context, int index, PageController pageController){
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
        backgroundColor: Color(0xff040307),
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.homeOutline)),
        CustomNavigationBarItem(icon: Icon(EvaIcons.monitorOutline)),
        CustomNavigationBarItem(icon: Icon(EvaIcons.messageCircleOutline)),
        CustomNavigationBarItem(icon: Icon(EvaIcons.starOutline)),
        CustomNavigationBarItem(icon: Icon(EvaIcons.peopleOutline))
    // CircleAvatar(
    // radius: 35.0,
    // backgroundColor: constantColors.blueGreyColor,
    // backgroundImage: NetworkImage(Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,)
    // ))
      ]
    );
  }
}