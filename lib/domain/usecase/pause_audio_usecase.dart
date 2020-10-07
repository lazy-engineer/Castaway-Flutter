import 'package:castaway/core/failure.dart';
import 'package:castaway/core/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';

class PauseAudioUseCase implements UseCase<void, NoParams> {
  final AudioPlayer player;

  PauseAudioUseCase(this.player);

  @override
  Future<Either<Failure, void>> execute(NoParams params) async {
    try {
      return Right(await player.pause());
    } catch (e) {
      return Left(AudioPlayerFailure());
    }
  }
}
