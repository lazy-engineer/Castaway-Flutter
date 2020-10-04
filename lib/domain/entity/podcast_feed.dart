import 'package:castaway/domain/entity/episode.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PodcastFeed extends Equatable {
  final String title;
  final String description;
  final List<Episode> episodes;

  PodcastFeed({
    @required this.title,
    @required this.description,
    @required this.episodes,
  });

  @override
  List<Object> get props => [title, description];

  @override
  bool get stringify => true;
}
