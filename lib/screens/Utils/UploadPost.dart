import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/LandingPage/landingServices.dart';
import 'package:the_sessions/services/Authentication.dart';
import 'package:the_sessions/services/FirebaseOperations.dart';

class UploadPost with ChangeNotifier{

  ConstantColors constantColors = ConstantColors();
  File uploadPostImage;
  File get getUploadPostImage => uploadPostImage;
  String uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  UploadTask imagePostUploadTask;
  TextEditingController captionController = TextEditingController();

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.getImage(source: source);
    uploadPostImageVal == null ? print('Select Image') : uploadPostImage = File(uploadPostImageVal.path);
    print(uploadPostImageVal.path);

    uploadPostImage != null ? showPostImage(context) : print('Image upload error');

    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
      'posts/${uploadPostImage.path}/${TimeOfDay.now()}'
    );
    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete((){
      print('Post image uploaded to storage');
    });
    imageReference.getDownloadURL().then((imageUrl){
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
    });
    notifyListeners();

  }


  selectPostImageType(BuildContext context){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.blueGreyColor,
          borderRadius: BorderRadius.circular(12.0)
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    pickUploadPostImage(context, ImageSource.gallery);
                  },
                  color: constantColors.blueColor,
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    pickUploadPostImage(context, ImageSource.camera);
                  },
                  color: constantColors.blueColor,
                  child: Text(
                    'Camera',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });

  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(context: context, builder: (context) {
      return Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.35,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.circular(12.0)
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Container(
                height: 200.0,
                width: 400.0,
                child: Image.file(uploadPostImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    child: Text(
                      'Reselect',
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: constantColors.whiteColor
                      ),
                    ),
                    onPressed: () {
                      selectPostImageType(context);
                    },
                  ),
                  MaterialButton(
                    color: constantColors.blueColor,
                    child: Text(
                      'Confirm Image',
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      uploadPostImageToFirebase().whenComplete((){
                        editPostSheet(context);
                        print('Image Uploaded!');
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  editPostSheet(BuildContext context){
    return showModalBottomSheet(isScrollControlled: true, context: context, builder: (context){
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
              child: Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        IconButton(icon: Icon(Icons.image_aspect_ratio),color: constantColors.greenColor, onPressed: () {}),
                        IconButton(icon: Icon(Icons.fit_screen),color: constantColors.yellowColor, onPressed: () {}),
                      ],
                    ),
                  ),
                  Container(
                    height: 200.0,
                    width: 300.0,
                    child: Image.file(uploadPostImage, fit: BoxFit.contain,),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: Image.asset('assets/icons/sunflower.png'),
                  ),
                  Container(
                    height: 110.0,
                    width: 5.0,
                    color: constantColors.blueColor,
                  ),
                  Container(
                    height: 120.0,
                    width: 330.0,
                    child: TextField(
                      maxLines: 5,
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100)
                      ],
                      maxLengthEnforced: true,
                      maxLength: 100,
                      controller: captionController,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add A Caption...',
                        hintStyle: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
            MaterialButton(
              onPressed: () async {
                Provider.of<FirebaseOperations>(context, listen: false).uploadPostData(
                  captionController.text, {
                    'caption': captionController.text,
                    'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
                    'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
                    'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
                    'time': Timestamp.now(),
                    'useremail': Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
                }).whenComplete((){
                  Navigator.pop(context);
                });
              },
              child: Text(
                'Share',
                style: TextStyle(
                  color: constantColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
                ),
              ),
              color: constantColors.blueColor,
            )
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.75,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.blueGreyColor,
          borderRadius: BorderRadius.circular(12.0)
        ),
      );
    });
  }


}