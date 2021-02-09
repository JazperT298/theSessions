import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/AltProfile/AltProfile.dart';
import 'package:the_sessions/screens/LandingPage/landingUtils.dart';
import 'package:the_sessions/screens/Messaging/GroupMessage.dart';
import 'package:the_sessions/services/Authentication.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatroomHelper with ChangeNotifier {
  String latestMessageTime;
  String get getLatestMessageTime => latestMessageTime;
  String chatroomAvatarUrl, chatroomId;
  String get getChatroomAvatarUrl => chatroomAvatarUrl;
  String get getChatroomId => chatroomId;

  ConstantColors constantColors = ConstantColors();
  final TextEditingController chatroomNameController = TextEditingController();

  showChatroomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.27,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.blueGreyColor,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Members',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return new Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () {
                                if (Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid !=
                                    documentSnapshot.data()['useruid']) {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid: documentSnapshot
                                                .data()['useruid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: constantColors.darkColor,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()['userimage']),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.blueGreyColor,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          documentSnapshot.data()['userimage'],
                        ),
                        backgroundColor: constantColors.transparent,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          documentSnapshot.data()['username'],
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  showCreateChatRoomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: 4.0,
                    ),
                  ),
                  Text(
                    'Select Chatroom Avatar',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomIcons')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  chatroomAvatarUrl =
                                      documentSnapshot.data()['image'];
                                  notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: chatroomAvatarUrl ==
                                                    documentSnapshot
                                                        .data()['image']
                                                ? constantColors.blueColor
                                                : constantColors.transparent)),
                                    height: 10.0,
                                    width: 40.0,
                                    child: Image.network(
                                        documentSnapshot.data()['image']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: chatroomNameController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                              hintText: 'Enter Chatroom ID',
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0)),
                        ),
                      ),
                      FloatingActionButton(
                          backgroundColor: constantColors.blueGreyColor,
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: constantColors.yellowColor,
                          ),
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .submitChatroomData(
                                    chatroomNameController.text, {
                              'roomavatar': getChatroomAvatarUrl,
                              'time': Timestamp.now(),
                              'roomname': chatroomNameController.text,
                              'username': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserName,
                              'userimage': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'useremail': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid
                            }).whenComplete(() {
                              Navigator.pop(context);
                            });
                          })
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.22,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0))),
            ),
          );
        });
  }

  showChatrooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 200.0,
                width: 200.0,
                child: Lottie.asset('assets/animations/loading.json'),
              ),
            );
          } else {
            return new ListView(
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return new ListTile(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: GroupMessage(
                                documentSnapshot: documentSnapshot),
                            type: PageTransitionType.leftToRight));
                  },
                  onLongPress: () {
                    showChatroomDetails(context, documentSnapshot);
                  },
                  trailing: Container(
                    width: 80.0,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(documentSnapshot.id)
                          .collection('messages')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        showLatestMessageTime(snapshot.data.docs.first.data()['time']);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Text(
                            getLatestMessageTime,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 9.0,
                                fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                  ),
                  title: Text(
                    documentSnapshot.data()['roomname'],
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('messages')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.data.docs.first.data()['username'] !=
                              null &&
                          snapshot.data.docs.first.data()['message'] != null) {
                        return Text(
                          '${snapshot.data.docs.first.data()['username']} : ${snapshot.data.docs.first.data()['message']}',
                          style: TextStyle(
                              color: constantColors.greenColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.data.docs.first.data()['username'] !=
                              null &&
                          snapshot.data.docs.first.data()['sticker'] != null) {
                        return Text(
                          '${snapshot.data.docs.first.data()['username']} sent a Sticker',
                          style: TextStyle(
                              color: constantColors.greenColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return Container(
                          width: 0.0,
                          height: 0.0,
                        );
                      }
                    },
                  ),
                  leading: CircleAvatar(
                    backgroundColor: constantColors.transparent,
                    // backgroundImage: AssetImage(
                    //     'assets/icons/sunflower.png'
                    // ),
                    // backgroundImage: NetworkImage(
                    //     'assets/icons/sunflower.png'
                    // )
                    backgroundImage:
                        NetworkImage(documentSnapshot.data()['roomavatar']),
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  showLatestMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    notifyListeners();
  }
}
