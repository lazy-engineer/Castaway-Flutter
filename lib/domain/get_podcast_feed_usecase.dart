import 'package:castaway/core/failures.dart';
import 'package:castaway/core/usecase.dart';
import 'package:castaway/domain/episode.dart';
import 'package:castaway/domain/podcast_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GetPodcastFeed implements UseCase<List<Episode>, Params> {
  final PodcastRepository repository;

  GetPodcastFeed(this.repository);

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
