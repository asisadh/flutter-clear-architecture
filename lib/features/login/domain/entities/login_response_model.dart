import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class LoginResponseModel extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  LoginResponseModel(
      {@required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.token})
      : super([firstName, lastName, email, token]);
}
