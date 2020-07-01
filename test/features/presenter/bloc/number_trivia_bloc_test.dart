import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/core/errors/failures.dart';
import 'package:learning/core/usecases/usecases.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learning/features/number_trivia/domain/usecases/get_concerete_number_trivia.dart';
import 'package:learning/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:learning/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:learning/utils/input_converter.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

main() {
  // ignore: close_sinks
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia concreteNumberTrivia;
  MockGetRandomNumberTrivia randomNumberTrivia;
  MockInputConverter inputConverter;

  setUp(() {
    concreteNumberTrivia = MockGetConcreteNumberTrivia();
    randomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        random: randomNumberTrivia,
        concrete: concreteNumberTrivia,
        inputConverter: inputConverter);
  });

  test('initial state should be empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tString = "1";
    final double tNUmber = 1;
    final trivia = NumberTrivia(number: 1, text: "test trivia");
    test(
        'should call the InputConverter to validate and convert the string to a double.',
        () async {
      //assign
      when(inputConverter.stringToDouble(any)).thenReturn(Right(tNUmber));

      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tString));
      await untilCalled(inputConverter.stringToDouble(any));
      //assert
      verify(inputConverter.stringToDouble(tString));
    });

    test('should emit [Error] when the input is invalid.', () async {
      //assign
      when(inputConverter.stringToDouble(any))
          .thenReturn(Left(InvalidInputFailure()));

      //assert Later
      final assertExpected = [
        Empty(),
        Error(message: ERROR_MESSAGE_FOR_INVALID_INPUTS),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(assertExpected));

      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tString));
      await untilCalled(inputConverter.stringToDouble(any));
    });

    test('should get data from the concerete use case.', () async {
      //assign
      when(inputConverter.stringToDouble(any)).thenReturn(Right(tNUmber));
      when(concreteNumberTrivia(any)).thenAnswer((_) async => Right(trivia));

      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tString));
      await untilCalled(concreteNumberTrivia(any));

      //assert
      verify(concreteNumberTrivia(Params(number: tNUmber)));
    });

    test('should emit [Loding, Loaded] when data is gotten successfully.',
        () async {
      //assign
      when(inputConverter.stringToDouble(any)).thenReturn(Right(tNUmber));
      when(concreteNumberTrivia(any)).thenAnswer((_) async => Right(trivia));

      //assert Later
      final assertExpected = [
        Empty(),
        Loading(),
        Loaded(trivia: trivia),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(assertExpected));

      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tString));
    });

    test('should emit [Loding, Error] when data fetch is unsuccessfully.',
        () async {
      //assign
      when(inputConverter.stringToDouble(any)).thenReturn(Right(tNUmber));
      when(concreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assert Later
      final assertExpected = [
        Empty(),
        Loading(),
        Error(message: SERVER_ERROR_MESSAGE),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(assertExpected));

      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tString));
    });

    test(
        'should emit [Loding, Error] when data fetch is unsuccessfully with proper message.',
        () async {
      //assign
      when(inputConverter.stringToDouble(any)).thenReturn(Right(tNUmber));
      when(concreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assert Later
      final assertExpected = [
        Empty(),
        Loading(),
        Error(message: CACHE_ERROR_MESSAGE),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(assertExpected));

      //act
      bloc.add(GetTriviaForConcreteNumber(numberString: tString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tString = "1";
    final double tNUmber = 1;
    final trivia = NumberTrivia(number: 1, text: "test trivia");

    test('should get data from the concerete use case.', () async {
      //assign
      when(randomNumberTrivia(any)).thenAnswer((_) async => Right(trivia));

      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(randomNumberTrivia(any));

      //assert
      verify(randomNumberTrivia(NoParams()));
    });

    test('should emit [Loding, Loaded] when data is gotten successfully.',
        () async {
      //assign
      when(randomNumberTrivia(any)).thenAnswer((_) async => Right(trivia));

      //assert Later
      final assertExpected = [
        Empty(),
        Loading(),
        Loaded(trivia: trivia),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(assertExpected));

      //act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loding, Error] when data fetch is unsuccessfully.',
        () async {
      //assign
      when(randomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assert Later
      final assertExpected = [
        Empty(),
        Loading(),
        Error(message: SERVER_ERROR_MESSAGE),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(assertExpected));

      //act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loding, Error] when data fetch is unsuccessfully with proper message.',
        () async {
      //assign
      when(randomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assert Later
      final assertExpected = [
        Empty(),
        Loading(),
        Error(message: CACHE_ERROR_MESSAGE),
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(assertExpected));

      //act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
