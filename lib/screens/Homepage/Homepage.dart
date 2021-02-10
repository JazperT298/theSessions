import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/ChatroomPage/Chatroom.dart';
import 'package:the_sessions/screens/FeedPage/Feed.dart';
import 'package:the_sessions/screens/Homepage/HomepageHelpers.dart';
import 'package:the_sessions/screens/ProfilePage/Profile.dart';
import 'package:the_sessions/screens/RewardsPage/Rewards.dart';
import 'package:the_sessions/screens/VideoconPage/Videocon.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FirebaseOperations>(context, listen: false).initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: PageView(
        controller: homepageController,
        children: [
          Feed(),
          Videocon(),
          Chatroom(),
          Rewards(),
          Profile(),
        ],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page){
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomepageHelpers>(context, listen: false).bottomNavBar(context, pageIndex, homepageController),
    );
  }
}
