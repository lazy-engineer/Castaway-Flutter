import 'dart:ui';

import 'package:castaway/domain/audio_repository.dart';
import 'package:castaway/domain/entity/podcast_feed.dart';
import 'package:castaway/domain/usecase/pause_audio_usecase.dart';
import 'package:castaway/domain/usecase/play_audio_usecase.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_bloc.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_event.dart';
import 'package:castaway/presentation/widget/episode_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';

class PodcastFeedScreen extends StatelessWidget {
  final PodcastFeed podcastFeed;

  const PodcastFeedScreen({
    Key key,
    @required this.podcastFeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildSliverEpisodes(context);
  }

  Widget _buildSliverEpisodes(BuildContext context) {
    final _player = AudioPlayer();
    final _audioRepo = AudioRepositoryImpl(player: _player);
    final _playAudio = PlayAudioUseCase(_audioRepo);
    final _pauseAudio = PauseAudioUseCase(_audioRepo);
    final _bloc =
        EpisodeTileBloc(playAudio: _playAudio, pauseAudio: _pauseAudio);

    return Container(
      color: Theme.of(context).highlightColor,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: PodcastSliverAppBar(
                podcastTitle: podcastFeed.title,
                imageUrl:
                    "http://storage.googleapis.com/androiddevelopers/android_developers_backstage/adb.png",
                expandedHeight: 200,
              ),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => EpisodeTile(
                  episode: podcastFeed.episodes[index],
                  bloc: _bloc,
                  onPausePressed: () {
                    _bloc.add(PauseEvent());
                  },
                  onPlayPressed: () {
                    _bloc.add(PlayEvent(podcastFeed.episodes[index].audioUrl));
                  },
                ),
                childCount: podcastFeed.episodes.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PodcastSliverAppBar extends SliverPersistentHeaderDelegate {
  final String podcastTitle;
  final String imageUrl;
  final double expandedHeight;

  PodcastSliverAppBar({
    @required this.podcastTitle,
    @required this.imageUrl,
    @required this.expandedHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Center(
          child: ClipPath(
            clipper: BottomWaveClipper(),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent
                        .withOpacity(shrinkOffset / expandedHeight),
                  ),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              podcastTitle,
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
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight * 0.75 - shrinkOffset,
          right: 24,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {},
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text("Subscribe".toUpperCase(),
                  style: TextStyle(fontSize: 14)),
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

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 1);

    var firstControlPoint = Offset(0, size.height * .85);
    var firstEndPoint = Offset(size.width / 6, size.height * .85);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width / 1.2, size.height * .85);

    var secControlPoint = Offset(size.width, size.height * .85);
    var secEndPoint = Offset(size.width, size.height * 1);

    path.quadraticBezierTo(
        secControlPoint.dx, secControlPoint.dy, secEndPoint.dx, secEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
