import 'package:castaway/podcast.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: EpisodeList(),
    );
  }
}

class EpisodeList extends StatefulWidget {
  @override
  _EpisodeListState createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  Widget build(BuildContext context) {
    Podcast().parse("https://feeds.feedburner.com/blogspot/androiddevelopersbackstage");
    return Container();
  }
}
