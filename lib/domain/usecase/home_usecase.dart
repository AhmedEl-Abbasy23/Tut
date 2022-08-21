import 'package:dartz/dartz.dart';
import 'package:flutter_advanced/data/network/failure.dart';
import 'package:flutter_advanced/domain/models/model.dart';
import 'package:flutter_advanced/domain/repository/repository.dart';
import 'package:flutter_advanced/domain/usecase/base_usecase.dart';

// void -> no inputs, only get data without request body.
class HomeUseCase implements BaseUseCase<void, Home> {
  final Repository _repository;

  HomeUseCase(this._repository);

  @override
  Future<Either<Failure, Home>> execute(void input) async {
    return await _repository.getHome();
  }
}
