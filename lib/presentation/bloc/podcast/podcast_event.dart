import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PodcastEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPodcastEpisodesEvent extends PodcastEvent {
  final String url;

  GetPodcastEpisodesEvent(this.url);

  @override
  List<Object> get props => [url];
}
