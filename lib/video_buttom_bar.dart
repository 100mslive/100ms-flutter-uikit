import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_uikit/meeting_store.dart';
import 'package:provider/provider.dart';

class VideoButtomBar extends StatefulWidget {
  final MeetingStore meetingStore;
  final List<Widget> addItem;
  const VideoButtomBar(
      {Key? key, required this.meetingStore, this.addItem = const []})
      : super(key: key);

  @override
  State<VideoButtomBar> createState() => _VideoButtomBarState();
}

class _VideoButtomBarState extends State<VideoButtomBar> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => widget.meetingStore,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Selector<MeetingStore, bool>(
              selector: (_, meetingStore) => meetingStore.isVideoOn,
              builder: (_, isVideoOn, __) {
                return Container(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                        tooltip: 'Video',
                        iconSize: 24,
                        onPressed: () {
                          widget.meetingStore.switchVideo();
                        },
                        icon: Icon(
                          isVideoOn ? Icons.videocam : Icons.videocam_off,
                          // color: Colors.grey.shade900,
                        )));
              },
            ),
            Selector<MeetingStore, bool>(
              selector: (_, meetingStore) => meetingStore.isMicOn,
              builder: (_, isMicOn, __) {
                return Container(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                        tooltip: 'Audio',
                        iconSize: 24,
                        onPressed: () {
                          widget.meetingStore.switchAudio();
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
                    widget.meetingStore.leave();
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
