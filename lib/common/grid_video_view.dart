//Package imports
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter_uikit/common/video_tile.dart';
import 'package:hmssdk_flutter_uikit/hms_video_call.dart';
import 'package:hmssdk_flutter_uikit/peer_track_node.dart';
import 'package:provider/provider.dart';

//Project imports
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

Widget gridVideoView(
    {required List<PeerTrackNode> peerTracks,
    required int itemCount,
    required int screenShareCount,
    required BuildContext context,
    required Size size}) {
  var padding = MediaQuery.of(context).viewPadding;
  return Padding(
    padding: EdgeInsets.only(top: padding.top),
    child: GridView.builder(
        shrinkWrap: true,
        cacheExtent: size.width,
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        itemBuilder: (context, index) {
          if (peerTracks[index].track?.source != "REGULAR") {
            return ChangeNotifierProvider.value(
              key: ValueKey(peerTracks[index].uid + "video_view"),
              value: peerTracks[index],
              child: peerTracks[index].peer.isLocal
                  ? Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.screen_share),
                          Text("You are sharing your screen"),
                        ],
                      ),
                    )
                  : VideoTile(
                      key: Key(peerTracks[index].uid + "video_tile"),
                      scaleType: ScaleType.SCALE_ASPECT_FIT,
                      itemHeight: size.height,
                      itemWidth: size.width,
                    ),
            );
          }

          if (screenShareCount == 0 &&
              index < 4 &&
              peerTracks[index].isOffscreen) {
            peerTracks[index].setOffScreenStatus(false);
          }
          return ChangeNotifierProvider.value(
              key: ValueKey(peerTracks[index].uid + "video_view"),
              value: peerTracks[index],
              child: VideoTile(
                key: ValueKey(peerTracks[index].uid + "audio_view"),
                itemHeight: size.height,
                itemWidth: size.width,
              ));
        },
        controller: Provider.of<HMSVideoCall>(context).controller,
        gridDelegate: SliverStairedGridDelegate(
            startCrossAxisDirectionReversed: false,
            pattern: pattern(itemCount, screenShareCount, size, padding))),
  );
}

List<StairedGridTile> pattern(
    int itemCount, int screenShareCount, Size size, EdgeInsets padding) {
  double ratio = (size.height -
          kBottomNavigationBarHeight -
          padding.bottom -
          padding.top -
          8) /
      (size.width);
  List<StairedGridTile> tiles = [];
  for (int i = 0; i < screenShareCount; i++) {
    tiles.add(StairedGridTile(1, ratio));
  }
  int normalTile = (itemCount - screenShareCount);
  int gridView = normalTile ~/ 4;
  int tileLeft = normalTile - (gridView * 4);
  for (int i = 0; i < (normalTile - tileLeft); i++) {
    tiles.add(StairedGridTile(0.5, ratio));
  }
  if (tileLeft == 1) {
    tiles.add(StairedGridTile(1, ratio));
  } else if (tileLeft == 2) {
    tiles.add(StairedGridTile(0.5, ratio / 2));
    tiles.add(StairedGridTile(0.5, ratio / 2));
  } else {
    tiles.add(StairedGridTile(1 / 3, ratio / 3));
    tiles.add(StairedGridTile(1 / 3, ratio / 3));
    tiles.add(StairedGridTile(1 / 3, ratio / 3));
  }
  return tiles;
}
