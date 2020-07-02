import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learning/core/errors/exceptions.dart';
import 'package:learning/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as Foundation;
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the https://numbersapi.com/{number} endpoint
  ///
  /// Throws [ServerException] for all error codes.
  Future<NumberTrivia> getContreteNumberTrivia(double number);

  /// Calls the https://numbersapi.com/random endpoint
  ///
  /// Throws [ServerException] for all error codes.
  Future<NumberTrivia> getRandomNumberTrivia();
}

const BASE_URL = 'http://numbersapi.com';
const RANDOM_END_POINT = '/random';

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  Future<NumberTrivia> getContreteNumberTrivia(double number) async {
    return _getConcreteOrRandomNumberTrivia(BASE_URL + '/$number');
  }

  Future<NumberTrivia> getRandomNumberTrivia() async {
    return _getConcreteOrRandomNumberTrivia(BASE_URL + RANDOM_END_POINT);
  }

  Future<NumberTrivia> _getConcreteOrRandomNumberTrivia(url) async {
    if (Foundation.kDebugMode) {
      log("url : $url");
    }

    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});

    final statusCode = response.statusCode;
    if (statusCode != null && statusCode == 200) {
      return NumberTriviaModel.fromJSON(json.decode(response.body));
    }
    throw ServerException();
  }
}
