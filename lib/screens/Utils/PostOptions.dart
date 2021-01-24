import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/services/Authentication.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

class PostFunctions with ChangeNotifier{
  TextEditingController commentController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').doc(subDocId).set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
      'time': Timestamp.now(),
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(comment).set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
      'time': Timestamp.now(),
    });
  }
  
  showCommentsSheet(BuildContext context, DocumentSnapshot snapshot, String docId){
    return showModalBottomSheet(isScrollControlled: true, context: context, builder: (context){
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width,
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
                width: 100.0,
                decoration: BoxDecoration(
                  border: Border.all(color: constantColors.whiteColor),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child: Text(
                    'Comments',
                    style: TextStyle(
                      color: constantColors.blueColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.62,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('posts').doc(docId).collection('comments').orderBy('time').snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }else{
                      return new ListView(
                        children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot){
                          return Container(
                            height: MediaQuery.of(context).size.height * 11,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: CircleAvatar(
                                        backgroundColor: constantColors.blueColor,
                                        radius: 15.0,
                                        backgroundImage: NetworkImage(
                                          documentSnapshot.data()['userimage']
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                documentSnapshot.data()['username'],
                                                style: TextStyle(
                                                  color: constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(icon: Icon(FontAwesomeIcons.arrowUp, color: constantColors.blueColor,), onPressed: () {}),
                                          Text(
                                            '0',
                                            style: TextStyle(
                                              color: constantColors.whiteColor,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          IconButton(icon: Icon(FontAwesomeIcons.reply, color: constantColors.yellowColor,), onPressed: () {}),
                                          IconButton(icon: Icon(FontAwesomeIcons.trashAlt, color: constantColors.redColor,), onPressed: () {}),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(icon: Icon(Icons.arrow_forward_ios_outlined, color: constantColors.blueColor,size: 12.0,), onPressed: () {

                                      }),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Text(
                                          documentSnapshot.data()['comment'],
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 16.0
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: constantColors.darkColor.withOpacity(0.2),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
              Container(
                width: 400.0,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 300.0,
                      height: 20.0,
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Add Comment...',
                          hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        controller: commentController,
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        print('Adding a comment');
                        addComment(context, snapshot.data()['caption'], commentController.text);
                      },
                      backgroundColor: constantColors.greenColor,
                      child: Icon(FontAwesomeIcons.comment,
                      color: constantColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.0),
              topLeft: Radius.circular(12.0)
            )
          ),
        ),
      );
    });
  }
}