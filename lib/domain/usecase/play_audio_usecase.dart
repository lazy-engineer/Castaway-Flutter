import 'package:castaway/core/failure.dart';
import 'package:castaway/core/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';

class PlayAudioUseCase implements UseCase<void, Params> {
  final AudioPlayer player;

  PlayAudioUseCase(this.player);

  @override
  Future<Either<Failure, void>> execute(Params params) async {
    try {
      await player.setUrl(params.url);
      return Right(player.play());
    } catch (e) {
      return Left(AudioPlayerFailure());
    }
  }
}

class Params extends Equatable {
  final String url;

  Params({@required this.url});

  @override
  List<Object> get props => [url];
}
