import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:learning/core/errors/failures.dart';
import 'package:learning/core/usecases/usecases.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learning/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

// import '../../../../core/errors/failures.dart';
// import '../../domain/entities/number_trivia.dart';
// import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getContreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];
}
