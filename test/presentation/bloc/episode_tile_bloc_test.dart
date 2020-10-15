import 'package:castaway/core/failure.dart';
import 'package:castaway/domain/usecase/pause_audio_usecase.dart';
import 'package:castaway/domain/usecase/play_audio_usecase.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_bloc.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_event.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetPlayAudioUseCase extends Mock implements PlayAudioUseCase {}

class MockGetPauseAudioUseCase extends Mock implements PauseAudioUseCase {}

void main() {
  EpisodeTileBloc bloc;
  MockGetPlayAudioUseCase mockGetPlayAudioUseCase;
  MockGetPauseAudioUseCase mockGetPauseAudioUseCase;

  setUp(() {
    mockGetPlayAudioUseCase = MockGetPlayAudioUseCase();
    mockGetPauseAudioUseCase = MockGetPauseAudioUseCase();
    bloc = EpisodeTileBloc(
      playAudio: mockGetPlayAudioUseCase,
      pauseAudio: mockGetPauseAudioUseCase,
    );
  });

  group('EpisodeTileBloc', () {
    test('initial state should be Empty', () {
      expect(bloc.state, equals(Empty()));
    });

    test(
      'should emit [Buffering, Playing] when audio player starts playing',
      () async {
        // given
        when(mockGetPlayAudioUseCase.execute(any))
            .thenAnswer((_) async => Right("1"));

        // when
        bloc.add(PlayEvent(url: "podcast.url", episodeId: "1"));

        // then
        final expected = [
          Buffering(),
          Playing(),
        ];
        expectLater(bloc, emitsInOrder(expected));
      },
    );

    test(
      'should emit [Buffering, Error] with a proper message for the error when audio player fail to play',
      () async {
        // given
        when(mockGetPlayAudioUseCase.execute(any))
            .thenAnswer((_) async => Left(AudioPlayerFailure()));

        // when
        bloc.add(PlayEvent(url: "podcast.url", episodeId: "1"));

        // then
        final expected = [
          Buffering(),
          Error(message: 'Unexpected error'),
        ];
        expectLater(bloc, emitsInOrder(expected));
      },
    );

    test(
      'should emit [Paused] when audio player pauses',
      () async {
        // given
        when(mockGetPauseAudioUseCase.execute(any))
            .thenAnswer((_) async => Right("1"));

        // when
        bloc.add(PauseEvent());

        // then
        final expected = Paused(episodeId: "1");

        expectLater(bloc, emits(expected));
      },
    );

    test(
      'should emit [Error] with a proper message for the error when audio player fail to pause',
      () async {
        // given
        when(mockGetPauseAudioUseCase.execute(any))
            .thenAnswer((_) async => Left(AudioPlayerFailure()));

        // when
        bloc.add(PauseEvent());

        // then
        final expected = Error(message: 'Unexpected error');

        expectLater(bloc, emits(expected));
      },
    );
  });
}
