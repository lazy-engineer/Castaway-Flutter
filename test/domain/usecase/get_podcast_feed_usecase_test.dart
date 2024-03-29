import 'package:castaway/domain/entity/podcast_feed.dart';
import 'package:castaway/domain/podcast_repository.dart';
import 'package:castaway/domain/usecase/get_podcast_feed_usecase.dart';
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

  final podcastFeed = PodcastFeed();
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
