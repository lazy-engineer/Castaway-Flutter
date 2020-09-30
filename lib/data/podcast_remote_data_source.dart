import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:webfeed/webfeed.dart';

abstract class PodcastRemoteDataSource {
  Future<RssFeed> getPodcast(String url);
}

class PodcastRemoteDataSourceImpl implements PodcastRemoteDataSource {
  final http.Client client;

  PodcastRemoteDataSourceImpl({@required this.client});

  @override
  Future<RssFeed> getPodcast(String url) => _getRSSFeedFromUrl(url);

  Future<RssFeed> _getRSSFeedFromUrl(String url) async {
    var response = await client.get(url);

    if (response.statusCode == 200) {
      return RssFeed.parse(response.body);
    } else {
      throw Exception();
    }
  }
}
