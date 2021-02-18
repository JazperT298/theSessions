import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/Enums/UserState.dart';
import 'package:the_sessions/Resources/AuthMethods.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/ChatroomPage/Chatroom.dart';
import 'package:the_sessions/screens/FeedPage/Feed.dart';
import 'package:the_sessions/screens/Homepage/HomepageHelpers.dart';
import 'package:the_sessions/screens/LandingPage/UserProvider.dart';
import 'package:the_sessions/screens/ProfilePage/Profile.dart';
import 'package:the_sessions/screens/RewardsPage/Rewards.dart';
import 'package:the_sessions/screens/VideoconPage/Videocon.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with WidgetsBindingObserver{
  ConstantColors constantColors = ConstantColors();
  PageController homepageController = PageController();
  int pageIndex = 0;
  final AuthMethods _authMethods = AuthMethods();
  UserProvider userProvider;


  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FirebaseOperations>(context, listen: false).initUserData(context);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      //will only execute after refreshUser finishes its execution
      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    homepageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
    (userProvider != null && userProvider.getUser != null)
        ? userProvider.getUser.uid
        : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page){
    setState(() {
      pageIndex = page;
    });
  }

  void navigationTapped(int page){
    homepageController.jumpToPage(page);
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
