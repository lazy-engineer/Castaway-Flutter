import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EpisodeTileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PlayEvent extends EpisodeTileEvent {
  final String url;
  final String episodeId;

  PlayEvent({
    @required this.url,
    @required this.episodeId,
  });

  @override
  List<Object> get props => [url, episodeId];
}

class PauseEvent extends EpisodeTileEvent {}
