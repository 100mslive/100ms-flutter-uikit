import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hmssdk_flutter_uikit/meeting_store.dart';
import 'package:hmssdk_flutter_uikit/video_call.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class NormalVideoCall extends StatefulWidget {
  final String token, name;
  final MeetingStore meetingStore;
  const NormalVideoCall(
      {required this.token,
      required this.name,
      required this.meetingStore,
      Key? key})
      : super(key: key);

  @override
  State<NormalVideoCall> createState() => _NormalVideoCallState();
}

class _NormalVideoCallState extends State<NormalVideoCall> {
  bool permission = false;
  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
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
        create: (context) => widget.meetingStore,
        child: Consumer<MeetingStore>(
          builder: (context, provider, child) => Selector<MeetingStore, bool>(
            selector: (_, meetingStore) => meetingStore.isMeetingStarted,
            builder: (context, isMeetingStarted, __) {
              if (context.read<MeetingStore>().isRoomEnded) {
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
                context.read<MeetingStore>().join(widget.name, widget.token);
                return const Center(
                  child: Text("Verify Room"),
                );
              } else {
                return const VideoCall();
              }
            },
          ),
        ));
  }
}
