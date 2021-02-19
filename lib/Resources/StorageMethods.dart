import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:the_sessions/Provider/ImageUploadProvider.dart';
import 'package:the_sessions/Resources/ChatMethods.dart';
import 'package:the_sessions/models/Users.dart';

class StorageMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseStorage _storageReference;
  Reference reference;

  //user class
  Users user = Users();

  Future<String> uploadImageToStorage(File imageFile) async {
    // mention try catch later on

    try {
      _storageReference = FirebaseStorage.instance;
      var url;
      reference = _storageReference
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      UploadTask  storageUploadTask = reference.putFile(imageFile);
       await (await storageUploadTask.whenComplete((){
        url = reference.getDownloadURL();
      }));
      return url;
    } catch (e) {
      return null;
    }
  }

  void uploadImage({
    @required File image,
    @required String receiverId,
    @required String senderId,
    @required ImageUploadProvider imageUploadProvider,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to user
    imageUploadProvider.setToLoading();

    // Get url from the image bucket
    String url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    chatMethods.setImageMsg(url, receiverId, senderId);
  }
}