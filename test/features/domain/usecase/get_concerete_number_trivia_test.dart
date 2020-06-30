import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learning/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:learning/features/number_trivia/domain/usecases/get_concerete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final testNumber = 1.0;
  final testNumberTrivia = NumberTrivia(number: testNumber, text: "");

  test('should get trivia for the number from the repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getContreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => Right(testNumberTrivia));

    //act
    final result = await usecase(Params(number: testNumber));

    //assert
    expect(result, Right(testNumberTrivia));
    verify(mockNumberTriviaRepository.getContreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
