import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/services/Authentication.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  String imageTimePosted;
  String get getImageTimePosted => imageTimePosted;

  showTimeAgo(dynamic timedata){
    Timestamp timestamp = timedata;
    DateTime dateTime = timestamp.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    notifyListeners();
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    });
  }

  showCommentsSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
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
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.53,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(docId)
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0),
                                          child: GestureDetector(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  constantColors.blueColor,
                                              radius: 15.0,
                                              backgroundImage: NetworkImage(
                                                  documentSnapshot
                                                      .data()['userimage']),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            child: Text(
                                              documentSnapshot
                                                  .data()['username'],
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.arrowUp,
                                                    color: constantColors
                                                        .blueColor,
                                                    size: 12.0,
                                                  ),
                                                  onPressed: () {}),
                                              Text(
                                                '0',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.reply,
                                                    color: constantColors
                                                        .yellowColor,
                                                    size: 12.0,
                                                  ),
                                                  onPressed: () {}),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: constantColors.blueColor,
                                                size: 12.0,
                                              ),
                                              onPressed: () {}),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                              documentSnapshot
                                                  .data()['comment'],
                                              style: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.trashAlt,
                                                color: constantColors.redColor,
                                                size: 16,
                                              ),
                                              onPressed: () {}),
                                        ],
                                      ),
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
                                  fontWeight: FontWeight.bold),
                            ),
                            controller: commentController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            print('Adding a comment');
                            addComment(context, snapshot.data()['caption'],
                                commentController.text).whenComplete((){
                                  commentController.clear();
                                  notifyListeners();
                            });
                          },
                          backgroundColor: constantColors.greenColor,
                          child: Icon(
                            FontAwesomeIcons.comment,
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
                      topLeft: Radius.circular(12.0))),
            ),
          );
        });
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
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
                      'Likes',
                      style: TextStyle(
                          color: constantColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return new ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot.data()['userimage']),
                                ),
                              ),
                              title: Text(
                                documentSnapshot.data()['username'],
                                style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              subtitle: Text(
                                documentSnapshot.data()['useremail'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot.data()['useruid']
                                  ? Container(
                                      width: 0.0,
                                      height: 0.0,
                                    )
                                  : MaterialButton(
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0),
                                      ),
                                      onPressed: () {},
                                      color: constantColors.blueColor,
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  showRewards(BuildContext context, String postId){
    return showModalBottomSheet(context: context, builder: (context){
       return Container(
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
                   'Rewards',
                   style: TextStyle(
                       color: constantColors.blueColor,
                       fontSize: 16.0,
                       fontWeight: FontWeight.bold),
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.only(top: 8.0),
               child: Container(
                 height: MediaQuery.of(context).size.height * 0.2,
                 child: StreamBuilder<QuerySnapshot>(
                   stream: FirebaseFirestore.instance.collection('awards').snapshots(),
                   builder: (context, snapshot){
                     if(snapshot.connectionState == ConnectionState.waiting){
                       return Center(
                         child: CircularProgressIndicator(),
                       );
                     }else{
                       return ListView(
                         scrollDirection: Axis.horizontal,
                         children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot){
                           return GestureDetector(
                             onTap: () async {
                                print(documentSnapshot.data()['image']);
                                await Provider.of<FirebaseOperations>(context, listen: false).addAward(postId, {
                                  'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
                                  'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
                                  'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
                                  'time': Timestamp.now(),
                                  'award': documentSnapshot.data()['image']
                                });
                             },
                             child: Padding(
                               padding: const EdgeInsets.only(left: 8.0),
                               child: Container(
                                 height: 50.0,
                                 width: 50.0,
                                 child: Image.network(documentSnapshot.data()['image']),
                               ),
                             ),
                           );
                         }).toList(),
                       );
                     }
                   },
                 ),
               ),
             ),
           ],
         ),
         decoration: BoxDecoration(
           color: constantColors.blueGreyColor,
           borderRadius: BorderRadius.only(
             topLeft: Radius.circular(12.0),
             topRight: Radius.circular(12.0)
           )
         ),
       );
    });
  }

}
