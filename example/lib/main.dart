import 'package:example_ui/room_service.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_uikit/hms_sdk_interactor.dart';
import 'package:hmssdk_flutter_uikit/meeting_store.dart';
import 'package:hmssdk_flutter_uikit/normal_video_call.dart';
import 'package:hmssdk_flutter_uikit/video_buttom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String?>? token;
  String msg = "Verifing you auth token";
  MeetingStore meetingStore =
      MeetingStore(hmsSDKInteractor: HMSSDKInteractor());

  @override
  void initState() {
    super.initState();
    joinRoom();
  }

  joinRoom() async {
    token = await RoomService().getToken(
        user: "Govind",
        room: "https://yogi.app.100ms.live/preview/ssz-eqr-eaa");
    if (token == null) {
      msg = "Fail to verify auth token";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: VideoButtomBar(
        meetingStore: meetingStore,
        
      ),
      body: token != null
          ? NormalVideoCall(
              token: token![0]!, meetingStore: meetingStore, name: "Govind")
          : Center(child: Text(msg)),
    );
  }
}
