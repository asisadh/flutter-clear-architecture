import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NumberTrivia extends Equatable {
  final String text;
  final double number;

  NumberTrivia({@required this.text, @required this.number})
      : super([number, text]);
}
