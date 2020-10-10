import 'package:castaway/domain/usecase/pause_audio_usecase.dart';
import 'package:castaway/domain/usecase/play_audio_usecase.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_bloc.dart';
import 'package:castaway/presentation/bloc/episode_tile/episode_tile_state.dart';
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

  group('PlayAudioUseCase', () {
    test('initial state should be Empty', () {
      expect(bloc.state, equals(Empty()));
    });
  });
}
