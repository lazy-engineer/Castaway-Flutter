import 'package:castaway/core/failure.dart';
import 'package:castaway/domain/entity/episode.dart';
import 'package:castaway/domain/entity/podcast_feed.dart';
import 'package:castaway/domain/usecase/get_podcast_feed_usecase.dart';
import 'package:castaway/presentation/bloc/podcast/podcast_bloc.dart';
import 'package:castaway/presentation/bloc/podcast/podcast_event.dart';
import 'package:castaway/presentation/bloc/podcast/podcast_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetPodcastFeedUseCase extends Mock implements GetPodcastFeedUseCase {}

void main() {
  PodcastBloc bloc;
  MockGetPodcastFeedUseCase mockGetPodcastFeedUseCase;

  setUp(() {
    mockGetPodcastFeedUseCase = MockGetPodcastFeedUseCase();
    bloc = PodcastBloc(getPodcastFeed: mockGetPodcastFeedUseCase);
  });

  group('GetPodcastFeedUseCase', () {
    test('initial state should be Empty', () {
      expect(bloc.state, equals(Empty()));
    });

    test(
      'should emit [Loading, Loaded] when podcast feed is loaded successfully',
      () async {
        // given
        final List<Episode> episodes = List(2);
        episodes[0] = Episode(
          title: "Episode 1",
          description: "Descriptions of Episode 1",
        );
        episodes[1] = Episode(
          title: "Episode 2",
          description: "Descriptions of Episode 2",
        );
        final podcastFeed = PodcastFeed(
          title: "Podcast Title",
          description: "Podcast Description",
          episodes: episodes,
        );

        when(mockGetPodcastFeedUseCase.execute(any))
            .thenAnswer((_) async => Right(podcastFeed));

        // when
        bloc.add(GetPodcastEpisodesEvent("podcast.url"));

        // then
        final expected = [
          Loading(),
          Loaded(podcastFeed: podcastFeed),
        ];
        expectLater(bloc, emitsInOrder(expected));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // given
        when(mockGetPodcastFeedUseCase.execute(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // when
        bloc.add(GetPodcastEpisodesEvent("podcast.url"));

        // then
        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
      },
    );
  });
}
