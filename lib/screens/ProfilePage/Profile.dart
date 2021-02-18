
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/Enums/UserState.dart';
import 'package:the_sessions/Resources/AuthMethods.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/LandingPage/UserProvider.dart';
import 'package:the_sessions/screens/LandingPage/landingPage.dart';
import 'package:the_sessions/screens/ProfilePage/ProfileHelpers.dart';
import 'package:the_sessions/services/Authentication.dart';

class Profile extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  final AuthMethods authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);


    googleSignOut() async {
      final bool isLoggedOut = await AuthMethods().signOut();
      if (isLoggedOut) {
        // set userState to offline as the user logs out'
        authMethods.setUserState(
          userId: userProvider.getUser.uid,
          userState: UserState.Offline,
        );

        // move the user to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Landingpage()),
              (Route<dynamic> route) => false,
        );
      }
    }

    logOutDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: constantColors.darkColor,
              title: Text(
                'Logout of theSessions? ',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                MaterialButton(
                    child: Text(
                      'No',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          decoration: TextDecoration.underline,
                          decorationColor: constantColors.whiteColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                MaterialButton(
                    color: constantColors.redColor,
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    onPressed: () {
                      googleSignOut();
                    }),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {

          },
          icon: Icon(EvaIcons.settings2Outline,
          color: constantColors.lightBlueColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(EvaIcons.logOutOutline,
            color: constantColors.greenColor,
            ),
            onPressed: () {
              logOutDialog(context);
            },
          )
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
            text: 'My ',
            style: TextStyle(
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Profile',
                style: TextStyle(
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              )
            ]
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(Provider.of<Authentication>(context, listen: false).getUserUid).snapshots(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }else{
                  return new Column(
                    children: [
                      Provider.of<ProfileHelpers>(context, listen: false).headerProfile(context, snapshot),
                      Provider.of<ProfileHelpers>(context, listen: false).divider(),
                      Provider.of<ProfileHelpers>(context, listen: false).middleProfile(context, snapshot),
                      Provider.of<ProfileHelpers>(context, listen: false).footerProfile(context, snapshot)
                    ],
                  );
                }
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: constantColors.blueGreyColor.withOpacity(0.6)
            ),
          ),
        ),
      ),
    );
  }


}
