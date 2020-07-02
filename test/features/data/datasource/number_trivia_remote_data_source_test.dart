import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learning/core/errors/exceptions.dart';
import 'package:learning/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:learning/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../stub/stub_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient client;

  void setUpHTTPCLient200() {
    when(client.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(stub('trivia.json'), 200));
  }

  ;

  void setUpHTTPCLient404() {
    when(client.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong.', 404));
  }

  ;

  setUp(() {
    client = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: client);
  });

  group('getContreteNumberTrivia', () {
    final int number = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJSON(json.decode(stub('trivia.json')));
    test('''should perform a GET request on a URL with number
    being the end point and with application/json header''', () async {
      //assign
      setUpHTTPCLient200();
      //act
      await dataSource.getContreteNumberTrivia(number);
      //assert
      verify(client.get(BASE_URL + '/$number',
          headers: {'Content-Type': 'application/json'}));
    });

    test('''should return a NumberTriviaModel if the network status is 200.''',
        () async {
      //assign
      setUpHTTPCLient200();
      //act
      final result = await dataSource.getContreteNumberTrivia(number);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        '''should return a Network Exception if the network status is not 200.''',
        () async {
      //assign
      setUpHTTPCLient404();
      //act
      final call = dataSource.getContreteNumberTrivia;
      //assert
      expect(() => call(number), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJSON(json.decode(stub('trivia.json')));
    test('''should perform a GET request on a URL without number
    being the end point and with application/json header''', () async {
      //assign
      setUpHTTPCLient200();
      //act
      await dataSource.getRandomNumberTrivia();
      //assert
      verify(client.get(BASE_URL + RANDOM_END_POINT,
          headers: {'Content-Type': 'application/json'}));
    });

    test('''should return a NumberTriviaModel if the network status is 200.''',
        () async {
      //assign
      setUpHTTPCLient200();
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        '''should return a Network Exception if the network status is not 200.''',
        () async {
      //assign
      setUpHTTPCLient404();
      //act
      final call = dataSource.getRandomNumberTrivia;
      //assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
