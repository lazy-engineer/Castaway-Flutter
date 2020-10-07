import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/podcast/podcast_bloc.dart';
import '../bloc/podcast/podcast_event.dart';

class FetchScreen extends StatelessWidget {
  const FetchScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _firePodcastEpisodesEvent(
      context,
      "https://feeds.feedburner.com/blogspot/androiddevelopersbackstage",
    );
    return Container();
  }

  void _firePodcastEpisodesEvent(BuildContext context, String url) {
    return BlocProvider.of<PodcastBloc>(context)
        .add(GetPodcastEpisodesEvent(url));
  }
}
