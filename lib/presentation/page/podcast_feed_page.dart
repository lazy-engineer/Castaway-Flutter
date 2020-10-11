import 'package:castaway/data/podcast_local_data_source.dart';
import 'package:castaway/data/podcast_remote_data_source.dart';
import 'package:castaway/domain/podcast_repository.dart';
import 'package:castaway/domain/usecase/get_podcast_feed_usecase.dart';
import 'package:castaway/presentation/widget/episodes_screen.dart';
import 'package:castaway/presentation/widget/error_screen.dart';
import 'package:castaway/presentation/widget/fetch_screen.dart';
import 'package:castaway/presentation/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../bloc/podcast/podcast_bloc.dart';
import '../bloc/podcast/podcast_state.dart';

class PodcastFeedPage extends StatefulWidget {
  @override
  _PodcastFeedPage createState() => _PodcastFeedPage();
}

class _PodcastFeedPage extends State<PodcastFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  BlocProvider<PodcastBloc> _buildBody(BuildContext context) {
    final _remote = PodcastRemoteDataSourceImpl(client: http.Client());
    final _local = PodcastLocalDataSourceImpl();
    final _repository = PodcastRepositoryImpl(
      remoteDataSource: _remote,
      localDataSource: _local,
    );
    final _getPodcastFeed = GetPodcastFeedUseCase(_repository);

    return BlocProvider(
      create: (_) => PodcastBloc(getPodcastFeed: _getPodcastFeed),
      child: Center(
        child: BlocBuilder<PodcastBloc, PodcastState>(
          builder: (context, state) {
            if (state is Empty) {
              return FetchScreen();
            } else if (state is Loading) {
              return LoadingScreen();
            } else if (state is Loaded) {
              return PodcastFeedScreen(podcastFeed: state.podcastFeed);
            } else if (state is Error) {
              return ErrorScreen(message: state.message);
            } else {
              return FetchScreen();
            }
          },
        ),
      ),
    );
  }
}
