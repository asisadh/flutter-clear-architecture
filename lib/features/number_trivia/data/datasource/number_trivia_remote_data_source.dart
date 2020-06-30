import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the https://numbersapi.com/{number} endpoint
  ///
  /// Throws [ServerException] for all error codes.
  Future<NumberTrivia> getContreteNumberTrivia(double number);

  /// Calls the https://numbersapi.com/random endpoint
  ///
  /// Throws [ServerException] for all error codes.
  Future<NumberTrivia> getRandomNumberTrivia();
}
