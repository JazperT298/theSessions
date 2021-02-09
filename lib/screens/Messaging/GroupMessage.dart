import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/Homepage/Homepage.dart';
import 'package:the_sessions/screens/Messaging/GroupMessageHelper.dart';
import 'package:the_sessions/services/Authentication.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  GroupMessage({@required this.documentSnapshot});

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final ConstantColors constantColors = ConstantColors();

  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GroupMessagingHelper>(context, listen: false).checkIfJoined(
        context,
        widget.documentSnapshot.id,
        widget.documentSnapshot.data()['useruid']).whenComplete(() async{
          if(Provider.of<GroupMessagingHelper>(context, listen: false).getHsMemberJoined == false){
            Timer(
              Duration(milliseconds: 10),
                () => Provider.of<GroupMessagingHelper>(context, listen: false).askToJoin(context, widget.documentSnapshot.id,)
            );
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {},
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
                      stream: FirebaseFirestore.instance.collection('chatrooms').doc(
                        widget.documentSnapshot.id
                      ).collection('members').snapshots(),
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }else{
                            return new Text(
                              '${snapshot.data.docs.length.toString()} members',
                              style: TextStyle(
                                  color: constantColors.greenColor.withOpacity(0.5),
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
}
