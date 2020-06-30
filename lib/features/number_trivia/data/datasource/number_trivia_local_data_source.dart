import 'package:learning/features/number_trivia/data/model/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotton the last time
  /// the user had an internet connection
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLatestNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel trivia);
}
