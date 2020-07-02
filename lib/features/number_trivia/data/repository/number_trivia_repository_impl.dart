import 'package:meta/meta.dart';
import 'package:learning/core/errors/exceptions.dart';
import 'package:learning/core/network/network_info.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learning/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTrivia> _GetConcreteOfRandomNumberTrivia();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getContreteNumberTrivia(
      int number) async {
    return await _getNumberTrivia(() {
      return remoteDataSource.getContreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getNumberTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getNumberTrivia(
      _GetConcreteOfRandomNumberTrivia getRandomOrConcreteNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await getRandomOrConcreteNumber();
        localDataSource.cacheNumberTrivia(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLatestNumberTrivia());
      } on CacheException {
        return left(CacheFailure());
      }
    }
  }
}
