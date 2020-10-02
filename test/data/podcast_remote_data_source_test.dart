import 'package:castaway/core/exceptions.dart';
import 'package:castaway/data/podcast_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:webfeed/domain/rss_feed.dart';

import '../resources/file_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  PodcastRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = PodcastRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(read('mock_rss_sample.xml'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getPodcast', () {
    final sampleRSSFeed = RssFeed.parse(read('mock_rss_sample.xml'));

    test(
      'should perform a successful GET request on given URL',
      () async {
        // given
        final requestUrl = "podcast.url";
        setUpMockHttpClientSuccess200();
        // when
        dataSource.getPodcast(requestUrl);
        // then
        verify(mockHttpClient.get(requestUrl));
      },
    );

    test(
      'should return equal rss feed title when the response code is 200',
      () async {
        // given
        setUpMockHttpClientSuccess200();
        // when
        final result = await dataSource.getPodcast("podcast.url");
        // then
        expect(result.title, equals(sampleRSSFeed.title));
      },
    );

    test(
      'should throw a ServerException when the response code is 404',
      () async {
        // given
        setUpMockHttpClientFailure404();
        // when
        final call = dataSource.getPodcast;
        // then
        expect(
            () => call("podcast.url"), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
