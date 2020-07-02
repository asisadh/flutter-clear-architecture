import 'package:meta/meta.dart';
import 'package:learning/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({@required String text, @required double number})
      : super(text: text, number: number);

  factory NumberTriviaModel.fromJSON(Map<String, dynamic> json) {
    return NumberTriviaModel(
        text: json['text'], number: (json['number'] as num).toDouble());
  }

  Map<String, dynamic> toJSON() {
    return {"text": text, "number": number};
  }
}
