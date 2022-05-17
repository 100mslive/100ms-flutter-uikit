import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_uikit/meeting_store.dart';
import 'package:hmssdk_flutter_uikit/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:draggable_widget/draggable_widget.dart';

class VideoCall extends StatelessWidget {
  const VideoCall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MeetingStore>(
      builder: (context, provider, child) =>
          Selector<MeetingStore, Tuple3<PeerTrackNode?, PeerTrackNode?, int>>(
        selector: (_, meetingStore) => Tuple3(
          meetingStore.peerTracks.isNotEmpty
              ? meetingStore.peerTracks[0]
              : null,
          meetingStore.peerTracks.length > 1
              ? meetingStore.peerTracks[1]
              : null,
          meetingStore.peerTracks.length,
        ),
        builder: (context, data, __) {
          if (data.item1!.track == null) {
            return const Center(
              child: Text("Please wait joining is in progress"),
            );
          }
          if (data.item3 == 1 && data.item1!.track != null) {
            return Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black54,
                  child: HMSVideoView(
                    track: data.item1!.track!,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.5)),
                ),
                const Center(
                  child: Text(
                    "Waiting for other peer to join",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }
          return Stack(
            children: [
              if (data.item2 != null && data.item2!.track != null)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: data.item2!.track!.isMute
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.videocam_off,
                                size: 50,
                                color: Colors.red,
                              ),                              
                              Text(
                                data.item2!.peer.name,
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        )
                      : HMSVideoView(
                          track: data.item2!.track!,
                        ),
                ),
              if (data.item1 != null && data.item1!.track != null)
                DraggableWidget(
                  topMargin: 50,
                  bottomMargin: 100,
                  horizontalSpace: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: SizedBox(
                      width: 100,
                      height: 150,
                      child: data.item1!.track!.isMute
                          ? const Center(
                              child: Icon(
                                Icons.videocam_off,
                                size: 32,
                                color: Colors.red,
                              ),
                            )
                          : HMSVideoView(
                              track: data.item1!.track!,
                            ),
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
