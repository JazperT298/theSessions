import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/AltProfile/AltProfile.dart';
import 'package:the_sessions/screens/Homepage/Homepage.dart';
import 'package:the_sessions/screens/Stories/StoriesHelper.dart';
import 'package:the_sessions/services/Authentication.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

class StoryWidgets {
  final ConstantColors constantColors = ConstantColors();
  final TextEditingController storyHighlightTitleController =
      TextEditingController();

  addStory(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Gallery',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Provider.of<StoriesHelper>(context, listen: false)
                              .selectStoryImage(context, ImageSource.gallery)
                              .whenComplete(() {});
                        }),
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          'Camera',
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Provider.of<StoriesHelper>(context, listen: false)
                              .selectStoryImage(context, ImageSource.camera)
                              .whenComplete(() {});
                        }),
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  previewStoryImage(BuildContext context, File storyImage) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
            ),
            child: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(storyImage)),
                Positioned(
                  top: 700.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          heroTag: 'Reselect Image',
                          backgroundColor: constantColors.redColor,
                          child: Icon(
                            FontAwesomeIcons.backspace,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {},
                        ),
                        FloatingActionButton(
                          heroTag: 'Confirm Image',
                          backgroundColor: constantColors.blueColor,
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {
                            Provider.of<StoriesHelper>(context, listen: false)
                                .uploadStoryImage(context)
                                .whenComplete(() async {
                              try {
                                if (Provider.of<StoriesHelper>(context,
                                            listen: false)
                                        .getStoryImageUrl !=
                                    null) {
                                  await FirebaseFirestore.instance
                                      .collection('stories')
                                      .doc(Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid)
                                      .set({
                                    'image': Provider.of<StoriesHelper>(context,
                                            listen: false)
                                        .getStoryImageUrl,
                                    'username': Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .getInitUserName,
                                    'userimage':
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .getInitUserImage,
                                    'time': Timestamp.now(),
                                    'useruid': Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUserUid
                                  }).whenComplete(() {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: Homepage(),
                                            type: PageTransitionType
                                                .bottomToTop));
                                  });
                                } else {
                                  return showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: constantColors.darkColor),
                                          child: Center(
                                            child: MaterialButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('stories')
                                                    .doc(Provider.of<
                                                                Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid)
                                                    .set({
                                                  'image': Provider.of<
                                                              StoriesHelper>(
                                                          context,
                                                          listen: false)
                                                      .getStoryImageUrl,
                                                  'username': Provider.of<
                                                              FirebaseOperations>(
                                                          context,
                                                          listen: false)
                                                      .getInitUserName,
                                                  'userimage': Provider.of<
                                                              FirebaseOperations>(
                                                          context,
                                                          listen: false)
                                                      .getInitUserImage,
                                                  'time': Timestamp.now(),
                                                  'useruid': Provider.of<
                                                              Authentication>(
                                                          context,
                                                          listen: false)
                                                      .getUserUid
                                                }).whenComplete(() {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child: Homepage(),
                                                          type:
                                                              PageTransitionType
                                                                  .bottomToTop));
                                                });
                                              },
                                              child: Text(
                                                'Upload Stories',
                                                style: TextStyle(
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              } catch (e) {
                                print(e.toString());
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  addToHighLights(BuildContext context, String storyImage) {
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
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Text(
                    'Add To Existing Album',
                    style: TextStyle(
                        color: constantColors.yellowColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    // Streambuilder of stories
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('users').doc(Provider.of<Authentication>(context, listen: false).getUserUid).collection('highlights').snapshots(),
                      builder: (context, snapshots){
                        if(snapshots.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }else{
                          return new ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshots.data.docs.map((DocumentSnapshot documentSnapshot){
                              return GestureDetector(
                                onTap: () {
                                  Provider.of<StoriesHelper>(context, listen: false).addStoryToExistingAlbum(context, documentSnapshot.id, Provider.of<Authentication>(context, listen: false).getUserUid,  storyImage);

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            documentSnapshot.data()['cover']
                                        ),
                                        backgroundColor: constantColors.darkColor,
                                        radius: 20.0,
                                      ),
                                      Text(
                                        documentSnapshot.data()['title'],
                                        style: TextStyle(
                                            color: constantColors.greenColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Text(
                    'Create New Album',
                    style: TextStyle(
                        color: constantColors.greenColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomIcons')
                          .snapshots(),
                      builder: (context, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshots.data.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  Provider.of<StoriesHelper>(context,
                                          listen: false)
                                      .convertHighlightedIcon(
                                          documentSnapshot.data()['image']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
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
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: storyHighlightTitleController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            decoration: InputDecoration(
                                hintText: 'Add Album Title...',
                                hintStyle: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0)),
                          ),
                        ),
                        FloatingActionButton(
                            backgroundColor: constantColors.blueColor,
                            child: Icon(
                              FontAwesomeIcons.check,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {
                              if (storyHighlightTitleController
                                  .text.isNotEmpty) {
                                Provider.of<StoriesHelper>(context,
                                        listen: false)
                                    .addStoryToNewAlbum(
                                        context,
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid,
                                        storyHighlightTitleController.text,
                                        storyImage);
                              } else {
                                return showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        color: constantColors.whiteColor,
                                        height: 100.0,
                                        width: 400.0,
                                        child: Center(
                                          child: Text('Add Album Title'),
                                        ),
                                      );
                                    });
                              }
                            })
                      ],
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: BorderRadius.circular(12.0)),
            ),
          );
        });
  }

  showViewers(BuildContext context, String storyId, String personUid) {
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stories')
                        .doc(storyId)
                        .collection('seen')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            Provider.of<StoriesHelper>(context, listen: false)
                                .storyTimePosted(
                                    documentSnapshot.data()['time']);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: constantColors.darkColor,
                                backgroundImage: NetworkImage(
                                  documentSnapshot.data()['userimage'],
                                ),
                                radius: 25.0,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.arrowCircleRight,
                                  color: constantColors.yellowColor,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                            userUid: documentSnapshot
                                                .data()['useruid'],
                                          ),
                                          type:
                                              PageTransitionType.bottomToTop));
                                },
                              ),
                              title: Text(
                                documentSnapshot.data()['username'],
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              subtitle: Text(
                                Provider.of<StoriesHelper>(context,
                                        listen: false)
                                    .getLastSeenTime
                                    .toString(),
                                style: TextStyle(
                                    color: constantColors.greenColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(12.0)),
          );
        });
  }

  previewAllHighlights(BuildContext context, String highlightTitle) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserUid)
                  .collection('highlights')
                  .doc(highlightTitle)
                  .collection('stories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return PageView(
                    children: snapshot.data.docs
                        .map((DocumentSnapshot documentSnapshot) {
                      return Container(
                        decoration: BoxDecoration(
                          color: constantColors.darkColor
                        ),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(documentSnapshot.data()['image']),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          );
        });
  }
}
