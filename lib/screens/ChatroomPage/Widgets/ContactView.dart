import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_sessions/Resources/AuthMethods.dart';
import 'package:the_sessions/Resources/ChatMethods.dart';
import 'package:the_sessions/models/Contact.dart';
import 'package:the_sessions/models/Users.dart';
import 'package:the_sessions/screens/ChatroomPage/ChatScreen.dart';
import 'package:the_sessions/screens/ChatroomPage/Widgets/OnlineDotIndicator.dart';
import 'package:the_sessions/screens/LandingPage/UserProvider.dart';
import 'package:the_sessions/widgets/CachedImage.dart';
import 'package:the_sessions/widgets/CustomTile.dart';

import 'LastMessageContainer.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Users>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Users user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final Users contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: true,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Text(
        //?. = Conditional Member Access Operator
        //contact?.name the same as contact != null ? contact.name : null

        //?? = If Null Operator
        //contact.name ?? ".." the same as contact.name != null ? contact.name : ".."

        (contact != null ? contact.name : null) != null ? contact.name : "..",
        style:
        TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 13),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 55, maxWidth: 55),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 45,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
