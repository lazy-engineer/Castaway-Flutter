import 'package:castaway/domain/entity/podcast_feed.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PodcastState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends PodcastState {}

class Loading extends PodcastState {}

class Loaded extends PodcastState {
  final PodcastFeed podcastFeed;

  Loaded({@required this.podcastFeed});

  @override
  List<Object> get props => [podcastFeed];
}

class Error extends PodcastState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
