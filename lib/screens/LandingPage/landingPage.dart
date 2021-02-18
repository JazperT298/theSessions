import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/Resources/AuthMethods.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/Homepage/Homepage.dart';
import 'package:the_sessions/screens/LandingPage/landingHelpers.dart';
import 'package:the_sessions/constants/Theme.dart' as Style;
import 'package:the_sessions/services/Authentication.dart';

// class Landingpage extends StatelessWidget {
//   final ConstantColors constantColors = ConstantColors();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: constantColors.whiteColor,
//       body: Stack(
//         children: <Widget>[
//           bodyColor(),
//           Provider.of<LandingHelpers>(context, listen: false).bodyImage(context),
//           Provider.of<LandingHelpers>(context, listen: false).taglineText(context),
//           Provider.of<LandingHelpers>(context, listen: false).mainButton(context),
//           Provider.of<LandingHelpers>(context, listen: false).privacyText(context)
//         ],
//       ),
//     );
//   }
//
//   bodyColor(){
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           stops: [
//             0.5,0.9
//           ],
//           colors: [
//             constantColors.darkColor,
//             constantColors.blueGreyColor
//           ]
//         )
//       ),
//     );
//   }
// }

class Landingpage extends StatefulWidget {
  @override
  _LandingpageState createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  final AuthMethods _authMethods = AuthMethods();

  bool isLoginPressed = false;

  ConstantColors constantColors = ConstantColors();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: constantColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 80.0),
          child: Form(
            child: Column(
              children: [
                Container(
                    height: 200.0,
                    padding: EdgeInsets.only(bottom: 20.0, top: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: 'the',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0),
                                children: <TextSpan>[
                              TextSpan(
                                text: 'Sessions',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: constantColors.blueGreyColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34.0),
                              )
                            ])),
                      ],
                    )),
                SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.bold),
                  controller: _usernameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(EvaIcons.emailOutline, color: Colors.black26),
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(30.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Style.Colors.mainColor),
                        borderRadius: BorderRadius.circular(30.0)),
                    contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                    labelText: "Email",
                    hintStyle: TextStyle(
                        fontSize: 12.0,
                        color: Style.Colors.grey,
                        fontWeight: FontWeight.w500),
                    labelStyle: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  autocorrect: false,
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Style.Colors.titleColor,
                      fontWeight: FontWeight.bold),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      EvaIcons.lockOutline,
                      color: Colors.black26,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(30.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Style.Colors.mainColor),
                        borderRadius: BorderRadius.circular(30.0)),
                    contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                    labelText: "Password",
                    hintStyle: TextStyle(
                        fontSize: 12.0,
                        color: Style.Colors.grey,
                        fontWeight: FontWeight.w500),
                    labelStyle: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  autocorrect: false,
                  obscureText: true,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: new InkWell(
                      child: new Text(
                        "Forget password?",
                        style: TextStyle(color: Colors.black45, fontSize: 12.0),
                      ),
                      onTap: () {}),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                          height: 45,
                          child:
                              // state is LoginLoading
                              //     ? Column(
                              //   crossAxisAlignment:
                              //   CrossAxisAlignment.center,
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: <Widget>[
                              //     Center(
                              //         child: Column(
                              //           mainAxisAlignment:
                              //           MainAxisAlignment.center,
                              //           children: [
                              //             SizedBox(
                              //               height: 25.0,
                              //               width: 25.0,
                              //               child: CupertinoActivityIndicator(),
                              //             )
                              //           ],
                              //         ))
                              //   ],
                              // )
                              //     :
                              RaisedButton(
                                  color: Style.Colors.mainColor,
                                  disabledColor: Style.Colors.mainColor,
                                  disabledTextColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  onPressed: () {
                                    if (_usernameController.text.isNotEmpty ||
                                        _usernameController.text.isNotEmpty ||
                                        _passwordController.text.isNotEmpty) {
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .logIntoAccount(
                                              _usernameController.text,
                                              _passwordController.text)
                                          .whenComplete(() {
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: Homepage(),
                                                type: PageTransitionType
                                                    .bottomToTop));
                                      });
                                    } else {
                                      warningText(
                                          context, 'Fill all the fields');
                                    }
                                  },
                                  child: isLoginPressed ? Center(child: CircularProgressIndicator(),) : Text("LOG IN",
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)))),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Or connect using",
                      style: TextStyle(color: Colors.black26, fontSize: 12.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40.0,
                      width: 180.0,
                      child: RaisedButton(
                          color: Color(0xFF385c8e),
                          disabledColor: Style.Colors.mainColor,
                          disabledTextColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                EvaIcons.facebook,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text("Facebook",
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          )),
                    ),
                    Container(
                      width: 180.0,
                      height: 40.0,
                      child: RaisedButton(
                          color: Color(0xFFf14436),
                          disabledColor: Style.Colors.mainColor,
                          disabledTextColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            performGoogleLogin();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                EvaIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text("Google",
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        padding: EdgeInsets.only(bottom: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style: TextStyle(color: Style.Colors.grey),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5.0),
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Style.Colors.mainColor,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        )),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(15.0)),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }

  void performGoogleLogin() {
    print("tring to perform login");

    setState(() {
      isLoginPressed = true;
    });

    _authMethods.googleSignIn().then((User user) {
      if (user != null) {
        authenticateGoogleUser(user);
      } else {
        print("There was an error");
      }
    });
  }

  void authenticateGoogleUser(User user) {
    _authMethods.authenticateGoogleUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Homepage(), type: PageTransitionType.bottomToTop));
        });
      } else {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: Homepage(), type: PageTransitionType.bottomToTop));
      }
    });
  }
}
