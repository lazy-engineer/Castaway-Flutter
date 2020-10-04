import 'dart:ui';

import 'package:castaway/domain/entity/episode.dart';
import 'package:flutter/material.dart';

class PodcastFeedScreen extends StatelessWidget {
  final List<Episode> episodes;

  const PodcastFeedScreen({
    Key key,
    @required this.episodes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSliverEpisodes();
  }

  Widget _buildSliverEpisodes() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: PodcastSliverAppBar(expandedHeight: 200),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => _buildRow(episodes[index]),
              childCount: episodes.length,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(Episode episode) {
    return ListTile(
        title: Text(
      episode.title,
      style: TextStyle(fontSize: 18.0),
    ));
  }
}

class PodcastSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  PodcastSliverAppBar({@required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Center(
          child: ClipRect(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'http://storage.googleapis.com/androiddevelopers/android_developers_backstage/adb.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.1)),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              "MySliverAppBar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: 16,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Card(
              elevation: 10,
              child: SizedBox(
                height: 100,
                width: 100,
                child: Image.network(
                  "http://storage.googleapis.com/androiddevelopers/android_developers_backstage/adb.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
