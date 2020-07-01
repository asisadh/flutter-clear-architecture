import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/utils/input_converter.dart';
import 'package:mockito/mockito.dart';

main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  test('convert doubleString to double successfully', () {
    //assign
    final String doubleString = "1.0";
    final double doubleValue = 1.0;

    //act
    final result = inputConverter.stringToDouble(doubleString);

    //assert
    expect(result, Right(doubleValue));
  });

  test('try convert string to double return InvalidInputFailure', () {
    //assign
    final String stringString = "test";

    //act
    final result = inputConverter.stringToDouble(stringString);

    //assert
    expect(result, Left(InvalidInputFailure()));
  });

  test('should return InvalidInputFailure when tried with negative number', () {
    //assign
    final String stringString = "-123";

    //act
    final result = inputConverter.stringToDouble(stringString);

    //assert
    expect(result, Left(InvalidInputFailure()));
  });
}
