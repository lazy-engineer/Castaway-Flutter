import 'package:castaway/domain/episode.dart';
import 'package:flutter/material.dart';

class EpisodesScreen extends StatelessWidget {
  final List<Episode> episodes;

  const EpisodesScreen({
    Key key,
    @required this.episodes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildEpisodes();
  }

  Widget _buildEpisodes() {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: episodes.length,
      itemBuilder: (BuildContext _context, int i) {
        return _buildRow(episodes[i]);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _buildRow(Episode episode) {
    return ListTile(
        title: Text(
      episode.title,
      style: TextStyle(fontSize: 18.0),
    ));
  }
}
