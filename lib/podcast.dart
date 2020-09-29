import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class Podcast {
  RssFeed _feed;
  RssFeed get feed => _feed;

  void parse(String url) async {
    var client = http.Client();

    var response = await client
        .get(url);
    _feed = RssFeed.parse(response.body);

    client.close();
  }
}