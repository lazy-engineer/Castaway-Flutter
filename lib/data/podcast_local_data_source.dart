import 'package:webfeed/webfeed.dart';

abstract class PodcastLocalDataSource {
  Future<RssFeed> getPodcast(String url);
}
