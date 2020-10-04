import 'package:castaway/core/failure.dart';
import 'package:castaway/core/usecase.dart';
import 'package:castaway/domain/entity/episode.dart';
import 'package:castaway/domain/podcast_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetPodcastFeedUseCase implements UseCase<List<Episode>, Params> {
  final PodcastRepository repository;

  GetPodcastFeedUseCase(this.repository);

  @override
  Future<Either<Failure, List<Episode>>> execute(Params params) async {
    return await repository.getPodcastFeed(params.url);
  }
}

class Params extends Equatable {
  final String url;

  Params({@required this.url});

  @override
  List<Object> get props => [url];
}
