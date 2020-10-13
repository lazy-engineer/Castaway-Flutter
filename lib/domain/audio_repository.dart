import 'package:castaway/core/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

abstract class AudioRepository {
  Future<Either<Failure, void>> playAudio(String url);
  Future<Either<Failure, void>> pauseAudio();
}

class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayer player;

  AudioRepositoryImpl({
    @required this.player,
  });

  @override
  Future<Either<Failure, void>> pauseAudio() async {
    try {
      return Right(await player.pause());
    } catch (e) {
      return Left(AudioPlayerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> playAudio(String url) async {
    try {
      await player.setUrl(url);
      return Right(player.play());
    } catch (e) {
      return Left(AudioPlayerFailure());
    }
  }
}
