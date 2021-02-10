import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/screens/Stories/StoriesWidget.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

class StoriesHelper with ChangeNotifier {
  UploadTask imageUploadTask;
  final picker = ImagePicker();
  File storyImage;
  File get getStoryImage => storyImage;
  final StoryWidgets storyWidgets = StoryWidgets();
  String storyImageUrl, storyHighlightIcon;
  String get getStoryImageUrl => storyImageUrl;
  String get getStoryHighlightIcon => storyHighlightIcon;

  Future selectStoryImage(BuildContext context, ImageSource source) async {
    final pickedStoryImage = await picker.getImage(source: source);
    pickedStoryImage == null
        ? print('Error')
        : storyImage = File(pickedStoryImage.path);
    storyImage != null
        ? storyWidgets.previewStoryImage(context, storyImage)
        : print('Error');
    notifyListeners();
  }

  Future uploadStoryImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('stories/${getStoryImage.path}/${Timestamp.now()}');

    imageUploadTask = imageReference.putFile(getStoryImage);
    await imageUploadTask.whenComplete(() {
      print('Story image upload');
    });
    imageReference.getDownloadURL().then((url) {
      storyImageUrl = url;
      print(storyImageUrl);
    });
    notifyListeners();
  }

  Future convertHighlightedIcon(String firestoreImageUrl) async {
    storyHighlightIcon = firestoreImageUrl;
    print(storyHighlightIcon);
    notifyListeners();
  }

  Future addStoryToNewAlbum(BuildContext context, String userUid,
      String highlightName, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightName)
        .set({
      'title': highlightName,
      'cover': storyHighlightIcon
    }).whenComplete(() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('highlights')
          .doc(highlightName)
          .collection('stories')
          .add({
        'image': getStoryImageUrl,
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage,
      });
    });
  }
}
