import 'package:dartz/dartz.dart';
import 'package:learning/core/errors/failures.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getContreteNumberTrivia(double number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
