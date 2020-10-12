import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EpisodeTileState extends Equatable {
  @override
  List<Object> get props => [];
}

class Empty extends EpisodeTileState {}

class Buffering extends EpisodeTileState {}

class Playing extends EpisodeTileState {}

class Paused extends EpisodeTileState {}

class Error extends EpisodeTileState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
