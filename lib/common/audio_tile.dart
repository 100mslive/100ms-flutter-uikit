// Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_uikit/common/audio_level_avatar.dart';
import 'package:hmssdk_flutter_uikit/common/audio_mute_status.dart';

import 'package:hmssdk_flutter_uikit/common/peer_name.dart';
import 'package:hmssdk_flutter_uikit/common/tile_border.dart';
import 'package:hmssdk_flutter_uikit/peer_track_node.dart';
import 'package:provider/provider.dart';

// Project imports

class AudioTile extends StatelessWidget {
  final double itemHeight;
  final double itemWidth;
  const AudioTile({this.itemHeight = 200.0, this.itemWidth = 200.0, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      key: key,
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.all(2),
      height: itemHeight + 110,
      width: itemWidth - 5.0,
      child: Stack(
        children: [
          const Center(child: AudioLevelAvatar()),
          PeerName(),

          AudioMuteStatus(), //bottom center
          TileBorder(
              name: context.read<PeerTrackNode>().peer.name,
              itemHeight: itemHeight,
              itemWidth: itemWidth,
              uid: context.read<PeerTrackNode>().uid)
        ],
      ),
    );
  }
}
