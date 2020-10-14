import 'package:castaway/core/failure.dart';
import 'package:castaway/core/usecase.dart';
import 'package:castaway/domain/audio_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PlayAudioUseCase implements UseCase<void, Params> {
  final AudioRepository repository;

  PlayAudioUseCase(this.repository);

  @override
  Future<Either<Failure, String>> execute(Params params) async {
    return await repository.playAudio(params.url, params.episodeId);
  }
}

class Params extends Equatable {
  final String url;
  final String episodeId;

  Params({
    @required this.url,
    @required this.episodeId,
  });

  @override
  List<Object> get props => [url, episodeId];
}
