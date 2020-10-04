import 'package:castaway/core/exception.dart';
import 'package:castaway/core/failure.dart';
import 'package:castaway/data/podcast_local_data_source.dart';
import 'package:castaway/data/podcast_remote_data_source.dart';
import 'package:castaway/domain/entity/episode.dart';
import 'package:castaway/domain/podcast_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

class MockRemoteDataSource extends Mock implements PodcastRemoteDataSource {}

class MockLocalDataSource extends Mock implements PodcastLocalDataSource {}

void main() {
  PodcastRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = PodcastRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource);
  });

  group('getPodcastFeed', () {
    List<RssItem> items = List(2);
    items[0] = RssItem(
      title: "RSS Item 1",
      description: "Descriptions of RSS Item 1",
      link: "Link of RSS Item 1",
    );
    items[1] = RssItem(
      title: "RSS Item 2",
      description: "Descriptions of RSS Item 2",
      link: "Link of RSS Item 2",
    );

    final feed = RssFeed(
      title: "Feed Title",
      author: "Feed Author",
      description: "Feed Description",
      link: "Feed Link",
      items: items,
    );

    final episodes = feed.items
        .map((e) => Episode(title: e.title, description: e.description))
        .toList();

    final requestUrl = "podcast.url";

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // given
        when(mockRemoteDataSource.loadPodcast(any))
            .thenAnswer((_) async => feed);
        // when
        final result = await repository.getPodcastFeed(requestUrl);
        // then
        verify(mockRemoteDataSource.loadPodcast(requestUrl));
        expect(result.toString(),
            equals(Right<Failure, List<Episode>>(episodes).toString()));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // given
        when(mockRemoteDataSource.loadPodcast(any))
            .thenThrow(ServerException());
        // when
        final result = await repository.getPodcastFeed(requestUrl);
        // then
        verify(mockRemoteDataSource.loadPodcast(requestUrl));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      },
    );
  });
}
