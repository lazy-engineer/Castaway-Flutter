import 'package:castaway/domain/entity/episode.dart';
import 'package:castaway/domain/entity/podcast_feed.dart';
import 'package:castaway/domain/get_podcast_feed_usecase.dart';
import 'package:castaway/domain/podcast_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPodcastRepository extends Mock implements PodcastRepository {}

void main() {
  GetPodcastFeedUseCase usecase;
  MockPodcastRepository mockRepository;

  setUp(() {
    mockRepository = MockPodcastRepository();
    usecase = GetPodcastFeedUseCase(mockRepository);
  });

  List<Episode> episodes = List(2);
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
  final podcastUrl = "podcast.url";

  test(
    'should get podcast feed for the feed url from the repository',
    () async {
      // given
      when(mockRepository.getPodcastFeed(any))
          .thenAnswer((_) async => Right(podcastFeed));
      // when
      final result = await usecase.execute(Params(url: podcastUrl));
      // then
      expect(result, Right(podcastFeed));
      verify(mockRepository.getPodcastFeed(podcastUrl));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
