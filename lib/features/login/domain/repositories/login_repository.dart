import 'package:dartz/dartz.dart';
import 'package:learning/core/errors/failures.dart';
import 'package:learning/features/login/domain/entities/login_response_model.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginResponseModel>> getLoginResponse();
}
