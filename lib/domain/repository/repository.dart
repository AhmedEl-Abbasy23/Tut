import 'package:dartz/dartz.dart';
import 'package:flutter_advanced/data/network/failure.dart';
import 'package:flutter_advanced/data/request/request.dart';
import 'package:flutter_advanced/domain/models/model.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure, ForgotPassword>> forgotPassword(ForgotPasswordRequest forgotPasswordRequest);
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest);
  Future<Either<Failure, Home>> getHome();
  Future<Either<Failure, StoreDetails>> getStoreDetails();
}
