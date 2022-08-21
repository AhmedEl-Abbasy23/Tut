import 'package:dartz/dartz.dart';
import 'package:flutter_advanced/app/functions.dart';
import 'package:flutter_advanced/data/network/failure.dart';
import 'package:flutter_advanced/data/request/request.dart';
import 'package:flutter_advanced/domain/models/model.dart';
import 'package:flutter_advanced/domain/repository/repository.dart';
import 'package:flutter_advanced/domain/usecase/base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  final Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    DeviceInfo deviceInfo = await getDeviceDetails();
    return await _repository.login(
      LoginRequest(
        input.email,
        input.password,
        deviceInfo.identifier, // imei
        deviceInfo.name, // deviceType
      ),
    );
  }
}

class LoginUseCaseInput {
  String email;
  String password;

  LoginUseCaseInput(this.email, this.password);
}
