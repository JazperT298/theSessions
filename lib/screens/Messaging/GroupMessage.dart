import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/Provider/ImageUploadProvider.dart';
import 'package:the_sessions/Resources/StorageMethods.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/Homepage/Homepage.dart';
import 'package:the_sessions/screens/Messaging/GroupMessageHelper.dart';
import 'package:the_sessions/services/Authentication.dart';
import 'package:the_sessions/utils/UniversalVariables.dart';
import 'package:the_sessions/utils/Utils.dart';
import 'package:the_sessions/widgets/CustomTile.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  GroupMessage({@required this.documentSnapshot});

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final ConstantColors constantColors = ConstantColors();

  final TextEditingController messageController = TextEditingController();
  //final StorageMethods _storageMethods = StorageMethods();

  String _currentUserId;

  bool isWriting = false;

  bool showEmojiPicker = false;

  ImageUploadProvider _imageUploadProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GroupMessagingHelper>(context, listen: false)
        .checkIfJoined(context, widget.documentSnapshot.id,
            widget.documentSnapshot.data()['useruid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessagingHelper>(context, listen: false)
              .getHsMemberJoined ==
          false) {
        Timer(
            Duration(milliseconds: 10),
            () => Provider.of<GroupMessagingHelper>(context, listen: false)
                    .askToJoin(
                  context,
                  widget.documentSnapshot.id,
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        actions: [
          Provider.of<Authentication>(context, listen: false).getUserUid ==
                  widget.documentSnapshot.data()['useruid']
              ? IconButton(
                  icon: Icon(
                    EvaIcons.moreVertical,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () {})
              : Container(
                  width: 0.0,
                  height: 0.0,
                ),
          IconButton(
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.redColor,
            ),
            onPressed: () {
              Provider.of<GroupMessagingHelper>(context, listen: false).leaveTheRoom(context, widget.documentSnapshot.id);
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Homepage(), type: PageTransitionType.leftToRight));
          },
        ),
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        title: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.darkColor,
                // backgroundImage: AssetImage('assets/icons/sunflower.png'),
                //wala pay avatar
                backgroundImage:
                    NetworkImage(widget.documentSnapshot.data()['roomavatar']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.documentSnapshot.data()['roomname'],
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatrooms')
                            .doc(widget.documentSnapshot.id)
                            .collection('members')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return new Text(
                              '${snapshot.data.docs.length.toString()} members',
                              style: TextStyle(
                                  color: constantColors.greenColor
                                      .withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                child: Provider.of<GroupMessagingHelper>(context, listen: false)
                    .showMessages(context, widget.documentSnapshot,
                        widget.documentSnapshot.data()['useruid']),
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<GroupMessagingHelper>(context,
                                  listen: false)
                              .showSticker(context, widget.documentSnapshot.id);
                        },
                        child: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: constantColors.transparent,
                          backgroundImage:
                              AssetImage('assets/icons/sunflower.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Drop a hi...',
                              hintStyle: TextStyle(
                                  color: constantColors.greenColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                          backgroundColor: constantColors.blueColor,
                          child: Icon(
                            Icons.send_sharp,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              Provider.of<GroupMessagingHelper>(context,
                                      listen: false)
                                  .sendMessage(context, widget.documentSnapshot,
                                      messageController);
                            }
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  //
  // void pickImage({@required ImageSource source}) async {
  //   File selectedImage = await Utils.pickImage(source: source);
  //   _storageMethods.uploadImage(
  //       image: selectedImage,
  //       receiverId: widget.receiver.uid,
  //       senderId: _currentUserId,
  //       imageUploadProvider: _imageUploadProvider);
  // }
  //
  // Widget chatControls() {
  //   setWritingTo(bool val) {
  //     setState(() {
  //       isWriting = val;
  //     });
  //   }
  //
  //   addMediaModal(context) {
  //     showModalBottomSheet(
  //         context: context,
  //         elevation: 0,
  //         backgroundColor: constantColors.darkColor,
  //         builder: (context) {
  //           return Column(
  //             children: <Widget>[
  //               Container(
  //                 padding: EdgeInsets.symmetric(vertical: 15),
  //                 child: Row(
  //                   children: <Widget>[
  //                     FlatButton(
  //                       child: Icon(
  //                         Icons.close,
  //                       ),
  //                       onPressed: () => Navigator.maybePop(context),
  //                     ),
  //                     Expanded(
  //                       child: Align(
  //                         alignment: Alignment.centerLeft,
  //                         child: Text(
  //                           "Content and tools",
  //                           style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 20,
  //                               fontWeight: FontWeight.bold),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Flexible(
  //                 child: ListView(
  //                   children: <Widget>[
  //                     ModalTile(
  //                       title: "Media",
  //                       subtitle: "Share Photos and Video",
  //                       icon: Icons.image,
  //                       onTap: () => pickImage(source: ImageSource.gallery),
  //                     ),
  //                     ModalTile(
  //                       title: "File",
  //                       subtitle: "Share files",
  //                       icon: Icons.tab,
  //                     ),
  //                     ModalTile(
  //                       title: "Contact",
  //                       subtitle: "Share contacts",
  //                       icon: Icons.contacts,
  //                     ),
  //                     ModalTile(
  //                       title: "Location",
  //                       subtitle: "Share a location",
  //                       icon: Icons.add_location,
  //                     ),
  //                     ModalTile(
  //                       title: "Schedule Call",
  //                       subtitle: "Arrange a skype call and get reminders",
  //                       icon: Icons.schedule,
  //                     ),
  //                     ModalTile(
  //                       title: "Create Poll",
  //                       subtitle: "Share polls",
  //                       icon: Icons.poll,
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           );
  //         });
  //   }
  //
  //   // sendMessage() {
  //   //   var text = textFieldController.text;
  //   //
  //   //   Message _message = Message(
  //   //     receiverId: widget.receiver.uid,
  //   //     senderId: sender.uid,
  //   //     message: text,
  //   //     timestamp: Timestamp.now(),
  //   //     type: 'text',
  //   //   );
  //   //
  //   //   setState(() {
  //   //     isWriting = false;
  //   //   });
  //   //
  //   //   textFieldController.text = "";
  //   //
  //   //   _chatMethods.addMessageToDb(_message, sender, widget.receiver);
  //   // }
  //
  //   // return Container(
  //   //   padding: EdgeInsets.all(10),
  //   //   child: Row(
  //   //     children: <Widget>[
  //   //       GestureDetector(
  //   //         onTap: () => addMediaModal(context),
  //   //         child: Container(
  //   //           padding: EdgeInsets.all(5),
  //   //           decoration: BoxDecoration(
  //   //             gradient: UniversalVariables.fabGradient,
  //   //             shape: BoxShape.circle,
  //   //           ),
  //   //           child: Icon(Icons.add),
  //   //         ),
  //   //       ),
  //   //       SizedBox(
  //   //         width: 5,
  //   //       ),
  //   //       Expanded(
  //   //         child: Stack(
  //   //           alignment: Alignment.centerRight,
  //   //           children: [
  //   //             TextField(
  //   //               controller: textFieldController,
  //   //               focusNode: textFieldFocus,
  //   //               onTap: () => hideEmojiContainer(),
  //   //               style: TextStyle(
  //   //                 color: Colors.white,
  //   //               ),
  //   //               onChanged: (val) {
  //   //                 (val.length > 0 && val.trim() != "")
  //   //                     ? setWritingTo(true)
  //   //                     : setWritingTo(false);
  //   //               },
  //   //               decoration: InputDecoration(
  //   //                 hintText: "Type a message",
  //   //                 hintStyle: TextStyle(
  //   //                   color: UniversalVariables.greyColor,
  //   //                 ),
  //   //                 border: OutlineInputBorder(
  //   //                     borderRadius: const BorderRadius.all(
  //   //                       const Radius.circular(50.0),
  //   //                     ),
  //   //                     borderSide: BorderSide.none),
  //   //                 contentPadding:
  //   //                 EdgeInsets.symmetric(horizontal: 20, vertical: 5),
  //   //                 filled: true,
  //   //                 fillColor: UniversalVariables.separatorColor,
  //   //               ),
  //   //             ),
  //   //             IconButton(
  //   //               splashColor: Colors.transparent,
  //   //               highlightColor: Colors.transparent,
  //   //               onPressed: () {
  //   //                 if (!showEmojiPicker) {
  //   //                   // keyboard is visible
  //   //                   hideKeyboard();
  //   //                   showEmojiContainer();
  //   //                 } else {
  //   //                   //keyboard is hidden
  //   //                   showKeyboard();
  //   //                   hideEmojiContainer();
  //   //                 }
  //   //               },
  //   //               icon: Icon(Icons.face),
  //   //             ),
  //   //           ],
  //   //         ),
  //   //       ),
  //   //       isWriting
  //   //           ? Container()
  //   //           : Padding(
  //   //         padding: EdgeInsets.symmetric(horizontal: 10),
  //   //         child: Icon(Icons.record_voice_over),
  //   //       ),
  //   //       isWriting
  //   //           ? Container()
  //   //           : GestureDetector(
  //   //         child: Icon(Icons.camera_alt),
  //   //         onTap: () => pickImage(source: ImageSource.camera),
  //   //       ),
  //   //       isWriting
  //   //           ? Container(
  //   //           margin: EdgeInsets.only(left: 10),
  //   //           decoration: BoxDecoration(
  //   //               gradient: UniversalVariables.fabGradient,
  //   //               shape: BoxShape.circle),
  //   //           child: IconButton(
  //   //             icon: Icon(
  //   //               Icons.send,
  //   //               size: 15,
  //   //             ),
  //   //             onPressed: () => sendMessage(),
  //   //           ))
  //   //           : Container()
  //   //     ],
  //   //   ),
  //   // );
  // }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
