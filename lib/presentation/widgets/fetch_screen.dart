import 'package:castaway/domain/get_podcast_feed_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../podcast_bloc.dart';
import '../podcast_event.dart';

class FetchScreen extends StatelessWidget {
  final String message;
  final GetPodcastFeedUseCase getPodcastFeed;

  const FetchScreen({
    Key key,
    @required this.message,
    @required this.getPodcastFeed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        textColor: Colors.white,
        color: Theme.of(context).accentColor,
        onPressed: () => _getPodcastEpisodesEvent(context,
            "https://feeds.feedburner.com/blogspot/androiddevelopersbackstage"),
        child: Text(message.toUpperCase()),
      ),
    );
  }

  void _getPodcastEpisodesEvent(BuildContext context, String url) {
    return BlocProvider.of<PodcastBloc>(context)
        .add(GetPodcastEpisodesEvent(url));
  }
}
