import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/Homepage/Homepage.dart';
import 'package:the_sessions/services/Authentication.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

class GroupMessagingHelper with ChangeNotifier {
  bool hasMemberJoined = false;
  bool get getHsMemberJoined => hasMemberJoined;
  ConstantColors constantColors = ConstantColors();

  showMessages(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUserId) {
    return StreamBuilder<QuerySnapshot>(
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
          } else {
            return new ListView(
              reverse: true,
              children:
                  snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.125,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                          child: Row(
                            children: [
                              // Positioned(
                              //   child: Provider.of<Authentication>(context,
                              //       listen: false)
                              //       .getUserUid ==
                              //       documentSnapshot.data()['useruid']
                              //       ? Container(
                              //     width: 0.0,
                              //     height: 0.0,
                              //   )
                              //       : CircleAvatar(
                              //     backgroundColor: constantColors.darkColor,
                              //     backgroundImage: NetworkImage(
                              //         documentSnapshot.data()['userimage']),
                              //   ),
                              // ),
                              Container(
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.1,
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.8),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 120.0,
                                        child: Row(
                                          children: [
                                            Text(
                                              documentSnapshot
                                                  .data()['username'],
                                              style: TextStyle(
                                                  color:
                                                      constantColors.greenColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0),
                                            ),
                                            Provider.of<Authentication>(context,
                                                            listen: false)
                                                        .getUserUid ==
                                                    adminUserId
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .chessKing,
                                                      color: constantColors
                                                          .yellowColor,
                                                      size: 12.0,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0.0,
                                                    height: 0.0,
                                                  )
                                          ],
                                        ),
                                      ),
                                      Text(
                                        documentSnapshot.data()['message'],
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getUserUid ==
                                            documentSnapshot.data()['useruid']
                                        ? constantColors.blueGreyColor
                                            .withOpacity(0.8)
                                        : constantColors.blueGreyColor,
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                              Positioned(
                                left: 50.0,
                                child: Provider.of<Authentication>(context,
                                    listen: false)
                                    .getUserUid ==
                                    documentSnapshot.data()['useruid']
                                    ? Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: constantColors.blueColor,
                                          size: 16.0,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.trashAlt,
                                          color: constantColors.redColor,
                                          size: 16.0,
                                        ),
                                        onPressed: () {},
                                      )
                                    ],
                                  ),
                                )
                                    : Container(
                                  width: 0.0,
                                  height: 0.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserUid ==
                                  documentSnapshot.data()['useruid']
                              ? Container(
                                  width: 0.0,
                                  height: 0.0,
                                )
                              : CircleAvatar(
                                  backgroundColor: constantColors.darkColor,
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()['userimage']),
                                ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
    });
  }

  Future checkIfJoined(BuildContext context, String chatRoomName, String chatRoomAdminUid) async {
    return FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomName).collection('members').doc(Provider.of<Authentication>(context, listen: false).getUserUid).get().then((value) {
      hasMemberJoined = false;
      print('Initial state => $hasMemberJoined');
      if(value.data()['joined'] != null){
        hasMemberJoined = value.data()['joined'];
        print('Final state => $hasMemberJoined');
        notifyListeners();
      }
      if(Provider.of<Authentication>(context, listen: false).getUserUid == chatRoomAdminUid){
        hasMemberJoined = true;
        notifyListeners();
      }

    });
  }

  askToJoin(BuildContext context, String roomName){
    return showDialog(context: context, builder: (context){
      return new AlertDialog(
        backgroundColor: constantColors.darkColor,
        title: Text(
          'Join $roomName?',
          style: TextStyle(
            color: constantColors.whiteColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              'No',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                decorationColor: constantColors.whiteColor,
                decoration: TextDecoration.underline
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(context, PageTransition(child: Homepage(), type: PageTransitionType.bottomToTop));
            },
          ),
          MaterialButton(
            color: constantColors.blueColor,
            child: Text(
              'Yes',
              style: TextStyle(
                  color: constantColors.whiteColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async{
              FirebaseFirestore.instance.collection('chatrooms').doc(roomName).collection('members').doc(
                Provider.of<Authentication>(context, listen: false).getUserUid
              ).set({
                'joined': true,
                'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
                'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
                'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
                'time': Timestamp.now(),
              }).whenComplete(() {
                Navigator.pop(context);
              });
            },
          )
        ],
      );
    });
  }
}
