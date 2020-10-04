import 'package:castaway/domain/entity/episode.dart';
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
  final List<Episode> episodes;

  Loaded({@required this.episodes});

  @override
  List<Object> get props => [episodes];
}

class Error extends PodcastState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
