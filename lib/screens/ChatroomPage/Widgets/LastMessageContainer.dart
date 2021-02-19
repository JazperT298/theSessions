import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_sessions/models/Message.dart';
import 'package:timeago/timeago.dart' as timeago;

class LastMessageContainer extends StatelessWidget {
  final stream;

  LastMessageContainer({
    @required this.stream,
  });
  String latestMessageTime;
  String get getLatestMessageTime => latestMessageTime;

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.docs;

          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data());
            showLatestMessageTime(message.timestamp);
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                '${message.message}       ${getLatestMessageTime}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            );
          }

          return Text(
            "No Message",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        }
        return Text(
          "..",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        );
      },
    );
  }
  showLatestMessageTime(Timestamp timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
  }
}