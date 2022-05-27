import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_uikit/common/full_screen_view.dart';
import 'package:hmssdk_flutter_uikit/common/grid_audio_view.dart';
import 'package:hmssdk_flutter_uikit/common/grid_hero_view.dart';
import 'package:hmssdk_flutter_uikit/common/grid_video_view.dart';
import 'package:hmssdk_flutter_uikit/enum/meeting_mode.dart';
import 'package:hmssdk_flutter_uikit/hms_video_call.dart';
import 'package:hmssdk_flutter_uikit/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class GroupCallUI extends StatefulWidget {
  final MeetingMode meetingMode;
  final bool activeSpeakerMode;
  const GroupCallUI(
      {required this.meetingMode, required this.activeSpeakerMode, Key? key})
      : super(key: key);

  @override
  State<GroupCallUI> createState() => _GroupCallUIState();
}

class _GroupCallUIState extends State<GroupCallUI> {
  @override
  void initState() {
    if (widget.activeSpeakerMode) {
      Provider.of<HMSVideoCall>(context, listen: false).setActiveSpeakerMode();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<HMSVideoCall>(
        builder: (context, provider, child) => Selector<HMSVideoCall,
                Tuple5<List<PeerTrackNode>, bool, int, int, PeerTrackNode?>>(
            selector: (_, meetingStore) => Tuple5(
                meetingStore.peerTracks,
                meetingStore.isHLSLink,
                meetingStore.peerTracks.length,
                meetingStore.screenShareCount,
                meetingStore.peerTracks.isNotEmpty
                    ? meetingStore.peerTracks[meetingStore.screenShareCount]
                    : null),
            builder: (_, data, __) {
              if (data.item3 == 0) {
                return const Center(
                  child: Text("Please wait joining is in progress"),
                );
              }
              if (widget.meetingMode == MeetingMode.Hero) {
                return gridHeroView(
                    peerTracks: data.item1,
                    itemCount: data.item3,
                    screenShareCount: data.item4,
                    context: context,
                    size: size);
              }
              if (widget.meetingMode == MeetingMode.Audio) {
                return gridAudioView(
                    peerTracks: data.item1.sublist(data.item4),
                    itemCount: data.item1.sublist(data.item4).length,
                    context: context,
                    size: size);
              }
              if (widget.meetingMode == MeetingMode.Single) {
                return fullScreenView(
                    peerTracks: data.item1,
                    itemCount: data.item3,
                    screenShareCount: data.item4,
                    context: context,
                    size: size);
              }
              return gridVideoView(
                  peerTracks: data.item1,
                  itemCount: data.item3,
                  screenShareCount: data.item4,
                  context: context,
                  size: size);
            }));
  }
}
