import 'package:flutter/material.dart';
import 'package:learning/core/errors/exceptions.dart';
import 'package:learning/core/platform/network_info.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learning/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/features/number_trivia/domain/repositories/number_trivia_repository.dart';

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
      double number) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getContreteNumberTrivia(number);
        localDataSource.cacheNumberTrivia(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Right(await localDataSource.getLatestNumberTrivia());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getRandomNumberTrivia();
        localDataSource.cacheNumberTrivia(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Right(await localDataSource.getLatestNumberTrivia());
    }
  }
}
