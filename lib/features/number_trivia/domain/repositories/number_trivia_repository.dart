import 'package:dartz/dartz.dart';
import '../../domain/entities/number_trivia.dart';
import '../../../../core/errors/failures.dart';

abstract class NumberTriviaRepository{
  Future<Either<Failure,NumberTrivia>> getContreteNumberTrivia(int number);
  Future<Either<Failure,NumberTrivia>> getRandomNumberTrivia();
}