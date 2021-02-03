import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/LandingPage/landingUtils.dart';
import 'package:the_sessions/services/Authentication.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

class ChatroomHelper with ChangeNotifier {
  String chatroomAvatarUrl, chatroomId;
  String get getChatroomAvatarUrl => chatroomAvatarUrl;
  String get getChatroomId => chatroomId;

  ConstantColors constantColors = ConstantColors();
  final TextEditingController chatroomNameController = TextEditingController();

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
                  title: Text(
                    documentSnapshot.data()['roomname'],
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Last message',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '2 hours ago',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: constantColors.transparent,
                    child: Image.asset('assets/icons/sunflower.png'),
                    // backgroundImage: NetworkImage(
                    //     'assets/icons/sunflower.png'
                    // )
                    // backgroundImage: NetworkImage(
                    //   documentSnapshot.data()['roomavatar']
                    // ),
                  ),
                );
              }).toList(),
            );
          }
        });
  }
}
