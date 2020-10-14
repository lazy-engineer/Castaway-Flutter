import 'package:castaway/core/failure.dart';
import 'package:castaway/core/usecase.dart';
import 'package:castaway/domain/audio_repository.dart';
import 'package:dartz/dartz.dart';

class PauseAudioUseCase implements UseCase<void, NoParams> {
  final AudioRepository repository;

  PauseAudioUseCase(this.repository);

  @override
  Future<Either<Failure, String>> execute(NoParams params) async {
    return await repository.pauseAudio();
  }
}
