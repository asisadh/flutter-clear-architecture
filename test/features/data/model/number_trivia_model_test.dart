import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learning/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../Stub/stub_reader.dart';

void main() {
  final tNumberTrivialModel = NumberTriviaModel(number: 1, text: "Text test");

  test('Should be an subclass of Number trivia entity', () async {
    //assert
    expect(tNumberTrivialModel, isA<NumberTrivia>());
  });

  group('from json', () {
    test('Should return a valid model when the JSON in an integer.', () async {
      //arrange
      String stringJSON = stub('trivia.json');
      final Map<String, dynamic> jsonMap = json.decode(stringJSON);

      //act
      final result = NumberTriviaModel.fromJSON(jsonMap);

      //assert
      expect(result, isA<NumberTriviaModel>());
      expect(result, tNumberTrivialModel);
    });

    test('Should return a valid model when the JSON in a double.', () async {
      //arrange
      String stringJSON = stub('trivia_double.json');
      final Map<String, dynamic> jsonMap = json.decode(stringJSON);

      //act
      final result = NumberTriviaModel.fromJSON(jsonMap);

      //assert
      expect(result, isA<NumberTriviaModel>());
      expect(result, tNumberTrivialModel);
    });
  });

  group('to json', () {
    test('return a json map containing a proper data', () async {
      //arrange

      //act
      final result = tNumberTrivialModel.toJSON();
      final expectedMap = {"text": "Text test", "number": 1};
      //assert
      expect(result, expectedMap);
    });
  });
}
