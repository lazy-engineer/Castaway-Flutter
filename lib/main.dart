import 'package:castaway/data/podcast_local_data_source.dart';
import 'package:castaway/data/podcast_remote_data_source.dart';
import 'package:castaway/presentation/podcast_bloc.dart';
import 'package:castaway/presentation/podcast_state.dart';
import 'package:castaway/presentation/widgets/episodes_screen.dart';
import 'package:castaway/presentation/widgets/error_screen.dart';
import 'package:castaway/presentation/widgets/fetch_screen.dart';
import 'package:castaway/presentation/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'domain/get_podcast_feed_usecase.dart';
import 'domain/podcast_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: EpisodeList(),
    );
  }
}

class EpisodeList extends StatefulWidget {
  @override
  _EpisodeListState createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  Widget build(BuildContext context) {
    return PodcastEpisodesPage();
  }
}

class PodcastEpisodesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podcast'),
      ),
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
          // ignore: missing_return
          builder: (context, state) {
            if (state is Empty) {
              return FetchScreen(
                message: 'Start fetching',
                getPodcastFeed: _getPodcastFeed,
              );
            } else if (state is Loading) {
              return LoadingScreen();
            } else if (state is Loaded) {
              return EpisodesScreen(episodes: state.episodes);
            } else if (state is Error) {
              return ErrorScreen(message: state.message);
            }
          },
        ),
      ),
    );
  }
}
