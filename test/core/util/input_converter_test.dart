import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/utils/input_converter.dart';

main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  test('convert String to int successfully', () {
    //assign
    final String string = "1";
    final int value = 1;

    //act
    final result = inputConverter.stringToInt(string);

    //assert
    expect(result, Right(value));
  });

  test('try convert string to double return InvalidInputFailure', () {
    //assign
    final String stringString = "test";

    //act
    final result = inputConverter.stringToInt(stringString);

    //assert
    expect(result, Left(InvalidInputFailure()));
  });

  test('should return InvalidInputFailure when tried with negative number', () {
    //assign
    final String stringString = "-123";

    //act
    final result = inputConverter.stringToInt(stringString);

    //assert
    expect(result, Left(InvalidInputFailure()));
  });

  test('should return InvalidInputFailure when tried with a null', () {
    //assign
    final String stringString = null;

    //act
    final result = inputConverter.stringToInt(stringString);

    //assert
    expect(result, Left(InvalidInputFailure()));
  });
}
