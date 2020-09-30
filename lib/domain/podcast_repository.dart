import 'package:castaway/core/failures.dart';
import 'package:castaway/data/podcast_local_data_source.dart';
import 'package:castaway/data/podcast_remote_data_source.dart';
import 'package:castaway/domain/episode.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

abstract class PodcastRepository {
  Future<Either<Failure, List<Episode>>> getPodcastFeed(String url);
}

class PodcastRepositoryImpl implements PodcastRepository {
  final PodcastRemoteDataSource remoteDataSource;
  final PodcastLocalDataSource localDataSource;

  PodcastRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Episode>>> getPodcastFeed(String url) async {
    try {
      final remote = await remoteDataSource.getPodcast(url);

      final episodes = remote.items
          .map((e) => Episode(title: e.title, description: e.description))
          .toList();

      return Right(episodes);
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
