import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:the_sessions/Resources/CallMethods.dart';
import 'package:the_sessions/constants/Strings.dart';
import 'package:the_sessions/models/Call.dart';
import 'package:the_sessions/screens/ChatroomPage/CallScreen.dart';
import 'package:the_sessions/utils/Permissions.dart';
import 'package:the_sessions/widgets/CachedImage.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();

  bool isCallMissed = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callbackDispatcher();
  }
  void callbackDispatcher() {
    print('callbackDispatcher');

    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.alarm,
      looping: true, // Android only - API >= 28
      volume: 0.1, // Android only - API >= 28
      //asAlarm: false, // Android only - all APIs
    );
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        FlutterRingtonePlayer.stop();
        return await callMethods.endCall(call: widget.call);
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Incoming...",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 50),
              CachedImage(
                widget.call.callerPic,
                isRound: true,
                radius: 180,
              ),
              SizedBox(height: 15),
              Text(
                widget.call.callerName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 75),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.call_end),
                    color: Colors.redAccent,
                    onPressed: () async {
                      FlutterRingtonePlayer.stop();
                      isCallMissed = false;
                      //addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await callMethods.endCall(call: widget.call);
                    },
                  ),
                  SizedBox(width: 25),
                  IconButton(
                      icon: Icon(Icons.call),
                      color: Colors.green,
                      onPressed: () async {
                        isCallMissed = false;
                        FlutterRingtonePlayer.stop();
                        //addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                        await Permissions.cameraAndMicrophonePermissionsGranted()
                            ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallScreen(call: widget.call),
                          ),
                        )
                            : () {};
                      }

                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
