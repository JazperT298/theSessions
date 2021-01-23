import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/constants/Constantcolors.dart';
import 'package:the_sessions/screens/LandingPage/landingServices.dart';

class LandingUtils with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final picker = ImagePicker();
  File userAvatar;
  File get getUserAvatar => userAvatar;
  String userAvatarUrl;
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.getImage(source: source);
    pickedUserAvatar == null ? print('Select Image') : userAvatar = File(pickedUserAvatar.path);
    print(userAvatar.path);

    userAvatar != null ? Provider.of<LandingService>(context, listen: false).showUserAvatar(context) : print('Image upload error');

    notifyListeners();
  }

  Future selectAvatarOptionsSheet(BuildContext context) async{
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: constantColors.blueColor,
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
                  color: constantColors.blueColor,
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                    ),
                  ),
                  onPressed: () {
                    pickUserAvatar(context, ImageSource.gallery).whenComplete(() {
                      Navigator.pop(context);
                      Provider.of<LandingService>(context, listen: false).showUserAvatar(context);
                    });
                  },
                ),
                MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    'Camera',
                    style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    ),
                  ),
                  onPressed: () {
                    pickUserAvatar(context, ImageSource.camera).whenComplete(() {
                      Navigator.pop(context);
                      Provider.of<LandingService>(context, listen: false).showUserAvatar(context);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
  }


}