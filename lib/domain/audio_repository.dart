import 'package:castaway/core/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

abstract class AudioRepository {
  Future<Either<Failure, String>> playAudio(String url, String episodeId);
  Future<Either<Failure, String>> pauseAudio();
}

class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayer player;
  String playingEpisodeId;

  AudioRepositoryImpl({
    @required this.player,
  });

  @override
  Future<Either<Failure, String>> pauseAudio() async {
    try {
      await player.pause();
      final pausedEpisodeId = playingEpisodeId;
      playingEpisodeId = null;
      return Right(pausedEpisodeId);
    } catch (e) {
      return Left(AudioPlayerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> playAudio(
      String url, String episodeId) async {
    try {
      if (playingEpisodeId != null) {
        pauseAudio();
      }

      await player.setUrl(url);
      player.play();
      playingEpisodeId = episodeId;

      return Right(playingEpisodeId);
    } catch (e) {
      return Left(AudioPlayerFailure());
    }
  }
}
