import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hmssdk_flutter_uikit/hms_video_call.dart';
import 'package:hmssdk_flutter_uikit/normal_video_call/video_call.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class NormalCall extends StatefulWidget {
  final String token, name;
  final HMSVideoCall hmsVideoCall;
  const NormalCall(
      {required this.token,
      required this.name,
      required this.hmsVideoCall,
      Key? key})
      : super(key: key);

  @override
  State<NormalCall> createState() => _NormalCallState();
}

class _NormalCallState extends State<NormalCall> {
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
            selector: (_, meetingStore) => meetingStore.isMeetingStarted,
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
                return const VideoCall();
              }
            },
          ),
        ));
  }
}
