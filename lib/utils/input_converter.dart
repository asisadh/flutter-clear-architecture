import 'package:dartz/dartz.dart';
import 'package:learning/core/errors/failures.dart';

class InputConverter {
  Either<Failure, double> stringToDouble(String string) {
    try {
      final number = double.parse(string);
      return number > 0 ? Right(number) : throw FormatException();
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}
