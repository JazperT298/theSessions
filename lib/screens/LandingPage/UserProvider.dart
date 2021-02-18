import 'package:flutter/material.dart';
import 'package:the_sessions/Resources/AuthMethods.dart';
import 'package:the_sessions/models/Users.dart';

class UserProvider with ChangeNotifier {
  Users _users;
  AuthMethods _authMethods = AuthMethods();

  Users get getUser => _users;
  //wait for this function to finish its execution inside the post frame callback with the help of await keyboard
  Future<void> refreshUser() async {
    //fetch the user details asynchronously which means user class object is initially null until the user details are fully fetch
    Users user = await _authMethods.getUserDetails();
    _users = user;
    notifyListeners();
  }

}