import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/core/errors/exceptions.dart';
import 'package:learning/core/errors/failures.dart';
import 'package:mockito/mockito.dart';

import 'package:learning/core/network/network_info.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:learning/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:learning/features/number_trivia/data/repository/number_trivia_repository_impl.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource remoteDataSource;
  MockLocalDataSource localDataSource;
  MockNetworkInfo networkInfo;

  void runTestOnline(Function body) {
    group('Device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('Device is Offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: networkInfo);
  });

  group('getConcreteNumberTrivia', () {
    final int testNumber = 1;
    final tNumnerTriviaModel =
        NumberTriviaModel(text: "test text", number: testNumber);

    final NumberTrivia tNumberTrivia = tNumnerTriviaModel;

    test('Should need to test if device is online', () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getContreteNumberTrivia(testNumber);
      //assert
      verify(networkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'Should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(remoteDataSource.getContreteNumberTrivia(any))
            .thenAnswer((_) async => tNumnerTriviaModel);
        //act
        final result = await repository.getContreteNumberTrivia(testNumber);
        //assert
        expect(result, equals(Right(tNumberTrivia)));
        verify(remoteDataSource.getContreteNumberTrivia(testNumber));
        verifyNever(localDataSource.getLatestNumberTrivia());
      });

      test(
          'Should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(remoteDataSource.getContreteNumberTrivia(any))
            .thenAnswer((_) async => tNumnerTriviaModel);
        //act
        await repository.getContreteNumberTrivia(testNumber);
        //assert
        verify(remoteDataSource.getContreteNumberTrivia(testNumber));
        verify(localDataSource.cacheNumberTrivia(tNumnerTriviaModel));
      });

      test(
          'Should return Server Exception when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(remoteDataSource.getContreteNumberTrivia(any))
            .thenThrow(ServerException());
        //act
        final result = await repository.getContreteNumberTrivia(testNumber);
        //assert
        expect(result, equals(Left(ServerFailure())));
        verifyZeroInteractions(localDataSource);
      });
    });

    runTestOffline(() {
      test(
          'Should return local data when the call to local data source is successful',
          () async {
        //arrange
        when(localDataSource.getLatestNumberTrivia())
            .thenAnswer((_) async => tNumnerTriviaModel);
        //act
        final result = await repository.getContreteNumberTrivia(testNumber);
        //assert
        expect(result, equals(Right(tNumberTrivia)));
        verify(localDataSource.getLatestNumberTrivia());
        verifyNever(remoteDataSource.getContreteNumberTrivia(testNumber));
      });

      test(
          'Should return Cache Error when the call to local data source is unsuccessful',
          () async {
        //arrange
        when(localDataSource.getLatestNumberTrivia())
            .thenThrow(CacheException());
        //act
        final result = await repository.getContreteNumberTrivia(testNumber);
        //assert
        expect(result, equals(left(CacheFailure())));
        verify(localDataSource.getLatestNumberTrivia());
        verifyNever(remoteDataSource.getContreteNumberTrivia(testNumber));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final int testNumber = 1;
    final tNumnerTriviaModel =
        NumberTriviaModel(text: "test text", number: testNumber);

    final NumberTrivia tNumberTrivia = tNumnerTriviaModel;

    test('Should need to test if device is online', () async {
      //arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getRandomNumberTrivia();
      //assert
      verify(networkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'Should return remote data when the call to remote data source is successful',
          () async {
        //arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumnerTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        expect(result, equals(Right(tNumberTrivia)));
        verify(remoteDataSource.getRandomNumberTrivia());
        verifyNever(localDataSource.getLatestNumberTrivia());
      });

      test(
          'Should cache the data locally when the call to remote data source is successful',
          () async {
        //arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumnerTriviaModel);
        //act
        await repository.getRandomNumberTrivia();
        //assert
        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(tNumnerTriviaModel));
        verifyNever(localDataSource.getLatestNumberTrivia());
      });

      test(
          'Should return Server Exception when the call to remote data source is unsuccessful',
          () async {
        //arrange
        when(remoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        expect(result, equals(Left(ServerFailure())));
        verifyZeroInteractions(localDataSource);
      });
    });

    runTestOffline(() {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
      test(
          'Should return local data when the call to local data source is successful',
          () async {
        //arrange
        when(localDataSource.getLatestNumberTrivia())
            .thenAnswer((_) async => tNumnerTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        expect(result, equals(Right(tNumberTrivia)));
        verify(localDataSource.getLatestNumberTrivia());
        verifyNever(remoteDataSource.getRandomNumberTrivia());
      });

      test(
          'Should return Cache Error when the call to local data source is unsuccessful',
          () async {
        //arrange
        when(localDataSource.getLatestNumberTrivia())
            .thenThrow(CacheException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        expect(result, equals(left(CacheFailure())));
        verify(localDataSource.getLatestNumberTrivia());
        verifyNever(remoteDataSource.getRandomNumberTrivia());
      });
    });
  });
}
