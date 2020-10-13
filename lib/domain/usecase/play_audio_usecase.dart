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
  Future<Either<Failure, void>> execute(Params params) async {
    return await repository.playAudio(params.url);
  }
}

class Params extends Equatable {
  final String url;

  Params({@required this.url});

  @override
  List<Object> get props => [url];
}
