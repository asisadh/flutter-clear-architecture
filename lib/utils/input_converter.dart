import 'package:dartz/dartz.dart';
import 'package:learning/core/errors/failures.dart';

class InputConverter {
  Either<Failure, int> stringToInt(String string) {
    try {
      if (string == null) {
        throw FormatException();
      }
      final number = int.parse(string);
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
