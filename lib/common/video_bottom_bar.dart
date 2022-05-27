import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_uikit/hms_video_call.dart';
import 'package:provider/provider.dart';

class VideoBottomBar extends StatefulWidget {
  final HMSVideoCall hmsVideoCall;
  final List<Widget> addItem;
  const VideoBottomBar(
      {Key? key, required this.hmsVideoCall, this.addItem = const []})
      : super(key: key);

  @override
  State<VideoBottomBar> createState() => _VideoBottomBarState();
}

class _VideoBottomBarState extends State<VideoBottomBar> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => widget.hmsVideoCall,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Selector<HMSVideoCall, bool>(
              selector: (_, meetingStore) => meetingStore.isVideoOn,
              builder: (_, isVideoOn, __) {
                return Container(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                        tooltip: 'Video',
                        iconSize: 24,
                        onPressed: () {
                          widget.hmsVideoCall.switchVideo();
                        },
                        icon: Icon(
                          isVideoOn ? Icons.videocam : Icons.videocam_off,
                          // color: Colors.grey.shade900,
                        )));
              },
            ),
            Selector<HMSVideoCall, bool>(
              selector: (_, meetingStore) => meetingStore.isMicOn,
              builder: (_, isMicOn, __) {
                return Container(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                        tooltip: 'Audio',
                        iconSize: 24,
                        onPressed: () {
                          widget.hmsVideoCall.switchAudio();
                        },
                        icon: Icon(
                          isMicOn ? Icons.mic : Icons.mic_off,
                        )));
              },
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                  color: Colors.white,
                  tooltip: 'Leave Or End',
                  iconSize: 24,
                  onPressed: () async {
                    widget.hmsVideoCall.leave();
                    // Navigator.pop(context);
                  },
                  icon: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.call_end, color: Colors.white),
                  )),
            ),
            ...widget.addItem,
          ],
        ));
  }
}
