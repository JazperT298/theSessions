import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:the_sessions/Resources/AuthMethods.dart';
import 'package:the_sessions/models/Users.dart';
import 'package:the_sessions/screens/ChatroomPage/ChatScreen.dart';
import 'package:the_sessions/screens/ChatroomPage/Pickup/PickupLayout.dart';
import 'package:the_sessions/utils/UniversalVariables.dart';
import 'package:the_sessions/widgets/CustomTile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthMethods _authMethods = AuthMethods();

  List<Users> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _authMethods.getCurrentUser().then((User user) {
      _authMethods.fetchAllUsers(user).then((List<Users> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return GradientAppBar(
      gradient: LinearGradient(
        colors: [
          UniversalVariables.gradientColorStart,
          UniversalVariables.gradientColorEnd,
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<Users> suggestionList = query.isEmpty
        ? []
        : userList != null
        ? userList.where((Users user) {
      String _getUsername = user.username.toLowerCase();
      String _query = query.toLowerCase();
      String _getName = user.name.toLowerCase();
      bool matchesUsername = _getUsername.contains(_query);
      bool matchesName = _getName.contains(_query);

      return (matchesUsername || matchesName);

      // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
      //     (user.name.toLowerCase().contains(query.toLowerCase()))),
    }).toList()
        : [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        Users searchedUser = Users(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            email: suggestionList[index].email);

        return CustomTile(
          mini: true,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      receiver: searchedUser,
                    )));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey
          ),
          title: Text(
            searchedUser.email,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(color: UniversalVariables.greyColor,fontSize: 12.0),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        appBar: searchAppBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(query),
        ),
      ),
    );
  }
}