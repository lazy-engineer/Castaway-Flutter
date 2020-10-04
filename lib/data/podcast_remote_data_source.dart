import 'package:castaway/core/exception.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:webfeed/webfeed.dart';

abstract class PodcastRemoteDataSource {
  Future<RssFeed> loadPodcast(String url);
}

class PodcastRemoteDataSourceImpl implements PodcastRemoteDataSource {
  final http.Client client;

  PodcastRemoteDataSourceImpl({@required this.client});

  @override
  Future<RssFeed> loadPodcast(String url) => _getRSSFeedFromUrl(url);

  Future<RssFeed> _getRSSFeedFromUrl(String url) async {
    var response = await client.get(url);

    if (response.statusCode == 200) {
      return RssFeed.parse(response.body);
    } else {
      throw ServerException();
    }
  }
}
