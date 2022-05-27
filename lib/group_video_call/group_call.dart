import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_uikit/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_uikit/group_video_call/group_call_ui.dart';

import 'package:hmssdk_flutter_uikit/hms_video_call.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class GroupCall extends StatefulWidget {
  final String token, name;
  final HMSVideoCall hmsVideoCall;
  final MeetingMode meetingMode;
  final bool activeSpeakerMode;
  const GroupCall(
      {required this.token,
      required this.name,
      required this.hmsVideoCall,
      this.meetingMode = MeetingMode.Video,
      this.activeSpeakerMode = false,
      Key? key})
      : super(key: key);

  @override
  State<GroupCall> createState() => _GroupCallState();
}

class _GroupCallState extends State<GroupCall> {
  bool permission = false;
  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();
    if (widget.meetingMode != MeetingMode.Audio) {
      while ((await Permission.camera.isDenied)) {
        await Permission.camera.request();
      }
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }

  initCall() async {
    permission = await getPermissions();
    setState(() {});
  }

  @override
  void initState() {
    initCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => widget.hmsVideoCall,
        child: Consumer<HMSVideoCall>(
          builder: (context, provider, child) => Selector<HMSVideoCall, bool>(
            selector: (_, videoCall) => videoCall.isMeetingStarted,
            builder: (context, isMeetingStarted, __) {
              if (context.read<HMSVideoCall>().isRoomEnded) {
                return const Center(
                  child: Text("Room Ended"),
                );
              }
              if (!permission) {
                return const Center(
                  child: Text("Accept camera and mic permission to continue"),
                );
              }
              if (!isMeetingStarted) {
                context.read<HMSVideoCall>().join(widget.name, widget.token);
                return const Center(
                  child: Text("Verify Room"),
                );
              } else {
                return GroupCallUI(
                  meetingMode: widget.meetingMode,
                  activeSpeakerMode: widget.activeSpeakerMode,
                );
              }
            },
          ),
        ));
  }
}
