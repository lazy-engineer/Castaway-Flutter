import 'package:castaway/core/failure.dart';
import 'package:castaway/data/podcast_local_data_source.dart';
import 'package:castaway/data/podcast_remote_data_source.dart';
import 'package:castaway/domain/entity/episode.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'entity/podcast_feed.dart';

abstract class PodcastRepository {
  Future<Either<Failure, PodcastFeed>> getPodcastFeed(String url);
}

class PodcastRepositoryImpl implements PodcastRepository {
  final PodcastRemoteDataSource remoteDataSource;
  final PodcastLocalDataSource localDataSource;

  PodcastRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, PodcastFeed>> getPodcastFeed(String url) async {
    try {
      final remote = await remoteDataSource.loadPodcast(url);

      final episodes = remote.items
          .map((e) => Episode(title: e.title, description: e.description))
          .toList();

      final podcastFeed = PodcastFeed(
        title: remote.title,
        description: remote.description,
        episodes: episodes,
      );

      return Right(podcastFeed);
    } on Exception {
      return Left(ServerFailure());
    }
  }
}
