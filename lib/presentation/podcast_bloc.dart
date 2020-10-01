import 'dart:async';

import 'package:castaway/core/failures.dart';
import 'package:castaway/domain/episode.dart';
import 'package:castaway/domain/get_podcast_feed_usecase.dart';
import 'package:castaway/presentation/podcast_event.dart';
import 'package:castaway/presentation/podcast_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';

class PodcastBloc extends Bloc<PodcastEvent, PodcastState> {
  final GetPodcastFeedUseCase getPodcastFeed;

  PodcastBloc({@required GetPodcastFeedUseCase getPodcastFeed})
      : assert(getPodcastFeed != null),
        getPodcastFeed = getPodcastFeed,
        super(Empty());

  @override
  Stream<PodcastState> mapEventToState(
    PodcastEvent event,
  ) async* {
    if (event is GetPodcastEpisodesEvent) {
      yield Loading();
      final failureOrPodcast =
          await getPodcastFeed.execute(Params(url: event.url));
      yield* _eitherLoadedOrErrorState(failureOrPodcast);
    }
  }

  Stream<PodcastState> _eitherLoadedOrErrorState(
    Either<Failure, List<Episode>> failureOrEpisodes,
  ) async* {
    yield failureOrEpisodes.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (episodes) => Loaded(episodes: episodes),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
