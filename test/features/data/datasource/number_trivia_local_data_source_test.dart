import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:learning/core/errors/exceptions.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:learning/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../stub/stub_reader.dart';

class MockSharedPreference extends Mock implements SharedPreferences {}

main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreference sharedPreference;

  setUp(() {
    sharedPreference = MockSharedPreference();
    dataSource =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: sharedPreference);
  });

  group('getLatestNumberTrivia', () {
    final tNUmberTriviaModel =
        NumberTriviaModel.fromJSON(json.decode(stub('cached_data.json')));
    test('should return LatestNumberTrivia if Found in local storage',
        () async {
      //arrange
      when(sharedPreference.getString(any))
          .thenReturn(stub('cached_data.json'));
      //act
      final result = await dataSource.getLatestNumberTrivia();
      //assert
      verify(sharedPreference.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNUmberTriviaModel));
      //
    });

    test('should throw CacheExecption if not found.', () async {
      //arrange
      when(sharedPreference.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getLatestNumberTrivia;
      //assert
      expect(() => call(), throwsA(isA<CacheException>()));
      //
    });
  });

  group('cacheNumberTrivia', () {
    final tNUmberTriviaModel = NumberTriviaModel(number: 1, text: "test text");
    test('should cached LatestNumberTrivia in local storage', () async {
      //act
      dataSource.cacheNumberTrivia(tNUmberTriviaModel);
      //assert
      final value = json.encode(tNUmberTriviaModel.toJSON());
      verify(sharedPreference.setString(CACHED_NUMBER_TRIVIA, value));
    });
  });
}
