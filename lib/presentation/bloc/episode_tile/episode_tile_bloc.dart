import 'package:castaway/core/failure.dart';
import 'package:castaway/core/usecase.dart';
import 'package:castaway/domain/usecase/pause_audio_usecase.dart';
import 'package:castaway/domain/usecase/play_audio_usecase.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_event.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class EpisodeTileBloc extends Bloc<EpisodeTileEvent, EpisodeTileState> {
  final PlayAudioUseCase playAudio;
  final PauseAudioUseCase pauseAudio;

  EpisodeTileBloc({
    @required PlayAudioUseCase playAudio,
    @required PauseAudioUseCase pauseAudio,
  })  : assert(playAudio != null),
        assert(pauseAudio != null),
        playAudio = playAudio,
        pauseAudio = pauseAudio,
        super(Empty());

  @override
  Stream<EpisodeTileState> mapEventToState(
    EpisodeTileEvent event,
  ) async* {
    if (event is PlayEvent) {
      yield Buffering();
      final failureOrPlaying = await playAudio.execute(Params(url: event.url));
      yield* _eitherPlayingOrErrorState(failureOrPlaying);
    }
    if (event is PauseEvent) {
      final failureOrPaused = await pauseAudio.execute(NoParams());
      yield* _eitherPausedOrErrorState(failureOrPaused);
    }
  }

  Stream<EpisodeTileState> _eitherPlayingOrErrorState(
    Either<Failure, void> failureOrPlaying,
  ) async* {
    yield failureOrPlaying.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (success) => Playing(),
    );
  }

  Stream<EpisodeTileState> _eitherPausedOrErrorState(
    Either<Failure, void> failureOrPaused,
  ) async* {
    yield failureOrPaused.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (success) => Paused(),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      default:
        return 'Unexpected error';
    }
  }
}
