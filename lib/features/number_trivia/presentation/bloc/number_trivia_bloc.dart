import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:learning/core/errors/failures.dart';
import 'package:learning/core/usecases/usecases.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learning/features/number_trivia/domain/usecases/get_concerete_number_trivia.dart';
import 'package:learning/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:learning/utils/input_converter.dart';
import 'package:meta/meta.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const ERROR_MESSAGE_FOR_INVALID_INPUTS = 'Please input valid params';
const SERVER_ERROR_MESSAGE = 'Something went wrong please try again later.';
const CACHE_ERROR_MESSAGE = 'No Cached Available';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {@required GetRandomNumberTrivia random,
      @required GetConcreteNumberTrivia concrete,
      @required this.inputConverter})
      : assert(random != null),
        assert(concrete != null),
        assert(inputConverter != null),
        getRandomNumberTrivia = random,
        getConcreteNumberTrivia = concrete;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = inputConverter.stringToDouble(event.numberString);
      yield* inputEither.fold((failure) async* {
        yield Error(message: ERROR_MESSAGE_FOR_INVALID_INPUTS);
      }, (number) async* {
        yield Loading();
        final result = await getConcreteNumberTrivia(Params(number: number));
        yield* _getNumberTriviaState(result);
      });
    }

    if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final result = await getRandomNumberTrivia(NoParams());
      yield* _getNumberTriviaState(result);
    }
  }

  Stream<NumberTriviaState> _getNumberTriviaState(
      Either<Failure, NumberTrivia> result) async* {
    yield result.fold((failure) => Error(message: failure._mapFailure()),
        (trivia) => Loaded(trivia: trivia));
  }
}

extension _MapFailureToMessage on Failure {
  String _mapFailure() {
    switch (this.runtimeType) {
      case ServerFailure:
        return SERVER_ERROR_MESSAGE;
      case CacheFailure:
        return CACHE_ERROR_MESSAGE;
      default:
        return "Something went wrong.";
    }
  }
}
