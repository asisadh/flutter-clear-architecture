import 'package:learning/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:learning/core/usecases/usecases.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learning/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
