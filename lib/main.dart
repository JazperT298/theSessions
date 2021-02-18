import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/Provider/ImageUploadProvider.dart';
import 'package:the_sessions/Resources/AuthMethods.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/AltProfile/AltProfileHelpers.dart';
import 'package:the_sessions/screens/ChatroomPage/ChatroomHelper.dart';
import 'package:the_sessions/screens/FeedPage/FeedHelpers.dart';
import 'package:the_sessions/screens/Homepage/Homepage.dart';
import 'package:the_sessions/screens/Homepage/HomepageHelpers.dart';
import 'package:the_sessions/screens/LandingPage/UserProvider.dart';
import 'package:the_sessions/screens/LandingPage/landingHelpers.dart';
import 'package:the_sessions/screens/LandingPage/landingServices.dart';
import 'package:the_sessions/screens/LandingPage/landingUtils.dart';
import 'package:the_sessions/screens/Messaging/GroupMessageHelper.dart';
import 'package:the_sessions/screens/ProfilePage/ProfileHelpers.dart';
import 'package:the_sessions/screens/RewardsPage/RewardsHelpers.dart';
import 'package:the_sessions/screens/Splashscreen/splashScreen.dart';
import 'package:the_sessions/screens/Stories/StoriesHelper.dart';
import 'package:the_sessions/screens/Utils/PostOptions.dart';
import 'package:the_sessions/screens/Utils/UploadPost.dart';
import 'package:the_sessions/screens/VideoconPage/VideoconHelpers.dart';
import 'package:the_sessions/services/Authentication.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthMethods _authMethods = AuthMethods();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    return MultiProvider(
      child: MaterialApp(
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<User> snapshot){
            if(snapshot.hasData){
              return Homepage();
            }else{
              return Splashscreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            accentColor: constantColors.blueColor,
            fontFamily: 'Poppins',
            canvasColor: Colors.transparent
        ),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => RewardsHelper()),
        ChangeNotifierProvider(create: (_) => VideoconHelpers()),
        ChangeNotifierProvider(create: (_) => StoriesHelper()),
        ChangeNotifierProvider(create: (_) => GroupMessagingHelper()),
        ChangeNotifierProvider(create: (_) => ChatroomHelper()),
        ChangeNotifierProvider(create: (_) => AltProfileHelper()),
        ChangeNotifierProvider(create: (_) => PostFunctions()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => FeedHelpers()),
        ChangeNotifierProvider(create: (_) => ProfileHelpers()),
        ChangeNotifierProvider(create: (_) => HomepageHelpers()),
        ChangeNotifierProvider(create: (_) => FirebaseOperations()),
        ChangeNotifierProvider(create: (_) => LandingService()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingHelpers()),
        ChangeNotifierProvider(create: (_) => LandingUtils())
      ],
    );
  }
}

