// Package imports
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:hmssdk_flutter_uikit/common/audio_mute_status.dart';
import 'package:hmssdk_flutter_uikit/common/degrade_tile.dart';
import 'package:hmssdk_flutter_uikit/common/peer_name.dart';
import 'package:hmssdk_flutter_uikit/common/tile_border.dart';
import 'package:hmssdk_flutter_uikit/common/video_view.dart';
import 'package:hmssdk_flutter_uikit/peer_track_node.dart';
import 'package:provider/provider.dart';

class VideoTile extends StatefulWidget {
  final double itemHeight;
  final double itemWidth;
  final ScaleType scaleType;

  const VideoTile(
      {Key? key,
      this.itemHeight = 200.0,
      this.itemWidth = 200.0,
      this.scaleType = ScaleType.SCALE_ASPECT_FILL})
      : super(key: key);

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  String name = "";
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusLost: () {
        if (mounted) {
          Provider.of<PeerTrackNode>(context, listen: false)
              .setOffScreenStatus(true);
        }
      },
      onFocusGained: () {
        Provider.of<PeerTrackNode>(context, listen: false)
            .setOffScreenStatus(false);
      },
      key: Key(context.read<PeerTrackNode>().uid),
      child: context.read<PeerTrackNode>().uid.contains("mainVideo")
          ? Container(
              key: key,
              margin: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: widget.itemHeight + 110,
              width: widget.itemWidth - 5.0,
              child: Stack(
                children: [
                  VideoView(
                    uid: context.read<PeerTrackNode>().uid,
                    scaleType: widget.scaleType,
                    itemHeight: widget.itemHeight,
                    itemWidth: widget.itemWidth,
                  ),

                  DegradeTile(
                    itemHeight: widget.itemHeight,
                    itemWidth: widget.itemWidth,
                  ),
                  PeerName(),
                  AudioMuteStatus(), //bottom center
                  TileBorder(
                      itemHeight: widget.itemHeight,
                      itemWidth: widget.itemWidth,
                      name: context.read<PeerTrackNode>().peer.name,
                      uid: context.read<PeerTrackNode>().uid)
                ],
              ),
            )
          : Container(
              color: Colors.transparent,
              key: key,
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(2),
              height: widget.itemHeight + 110,
              width: widget.itemWidth - 5.0,
              child: Stack(
                children: [
                  VideoView(
                    uid: context.read<PeerTrackNode>().uid,
                    scaleType: widget.scaleType,
                    itemHeight: widget.itemHeight,
                    itemWidth: widget.itemWidth,
                  ),
                  PeerName(),
                  Container(
                    height: widget.itemHeight + 110,
                    width: widget.itemWidth - 4,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                  )
                ],
              ),
            ),
    );
  }
}
