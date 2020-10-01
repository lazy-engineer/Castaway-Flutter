import 'package:webfeed/webfeed.dart';

abstract class PodcastLocalDataSource {
  Future<RssFeed> getPodcast(String url);
}

class PodcastLocalDataSourceImpl implements PodcastLocalDataSource {
  PodcastLocalDataSourceImpl();

  @override
  Future<RssFeed> getPodcast(String url) => null;
}
