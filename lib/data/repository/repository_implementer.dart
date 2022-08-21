import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_advanced/data/data_source/local_data_source.dart';
import 'package:flutter_advanced/data/data_source/remote_data_source.dart';
import 'package:flutter_advanced/data/network/error_handler.dart';
import 'package:flutter_advanced/data/network/failure.dart';
import 'package:flutter_advanced/data/network/network_info.dart';
import 'package:flutter_advanced/data/request/request.dart';
import 'package:flutter_advanced/domain/models/model.dart';
import 'package:flutter_advanced/domain/repository/repository.dart';
import 'package:flutter_advanced/data/mapper/mapper.dart';

class RepositoryImpl extends Repository {
  final NetworkInfo _networkInfo;
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  RepositoryImpl(
      this._networkInfo, this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call the API
        final response = await _remoteDataSource.login(loginRequest);
        // internal status from the API response
        if (response.status == ApiInternalStatus.SUCCESS) {
          // return data (success)
          // return right
          return Right(response.toDomain());
          // we converted the response to object (model) using mapper
        } else {
          // return business logic error
          // return left if I get error.
          return Left(Failure(
            response.status ?? ApiInternalStatus.FAILURE, // status code
            response.message ?? ResponseMessage.DEFAULT.tr(), // status message
          ));
        }
      } catch (error) {
        // if received an error while calling the response
        // will handle it here and return a Failure object here for the Either
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, ForgotPassword>> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call the API
        final response =
            await _remoteDataSource.forgotPassword(forgotPasswordRequest);
        // internal status from the API response
        if (response.status == ApiInternalStatus.SUCCESS) {
          // return data (success)
          // return right
          return Right(response.toDomain());
          // we converted the response to object (model) using mapper
        } else {
          // return business logic error
          // return left if I get error.
          return Left(Failure(
            response.status ?? ApiInternalStatus.FAILURE, // status code
            response.message ?? ResponseMessage.DEFAULT.tr(), // status message
          ));
        }
      } catch (error) {
        // if received an error while calling the response
        // will handle it here and return a Failure object here for the Either
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call the API
        final response = await _remoteDataSource.register(registerRequest);
        // internal status from the API response
        if (response.status == ApiInternalStatus.SUCCESS) {
          // return data (success)
          // return right
          return Right(response.toDomain());
          // we converted the response to object (model) using mapper
        } else {
          // return business logic error
          // return left if I get error.
          return Left(Failure(
            response.status ?? ApiInternalStatus.FAILURE, // status code
            response.message ?? ResponseMessage.DEFAULT.tr(), // status message
          ));
        }
      } catch (error) {
        // if received an error while calling the response
        // will handle it here and return a Failure object here for the Either
        return (Left(ErrorHandler.handle(error).failure));
      }
    } else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Home>> getHome() async {
    // firstly, try to get (homeData) from cache side if its exists and valid.
    try {
      final response = await _localDataSource.getHome();
      return Right(response.toDomain());
    } catch (cacheError) {
      // cacheError which received from localDataSource cachedItem.
      // cache isn't exists or isn't valid. -- now call API.
      // its the time to get from API side.
      if (await _networkInfo.isConnected) {
        try {
          final response = await _remoteDataSource.getHome();
          if (response.status == ApiInternalStatus.SUCCESS) {
            // save home response into cacheData (local data source).
            _localDataSource.saveHomeToCache(response);
            //
            return Right(response.toDomain());
          } else {
            return Left(Failure(
              response.status ?? ApiInternalStatus.FAILURE, // status code
              response.message ?? ResponseMessage.DEFAULT.tr(), // status message
            ));
          }
        } catch (error) {
          return (Left(ErrorHandler.handle(error).failure));
        }
      } else {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }

  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async{
    // firstly, try to get (homeData) from cache side if its exists and valid.
    try {
      final response = await _localDataSource.getStoreDetails();
      return Right(response.toDomain());
    } catch (cacheError) {
      // cacheError which received from localDataSource cachedItem.
      // cache isn't exists or isn't valid. -- now call API.
      // its the time to get from API side.
      if (await _networkInfo.isConnected) {
        try {
          final response = await _remoteDataSource.getStoreDetails();
          if (response.status == ApiInternalStatus.SUCCESS) {
            // save home response into cacheData (local data source).
            _localDataSource.saveStoreDetailsToCache(response);
            //
            return Right(response.toDomain());
          } else {
            return Left(Failure(
              response.status ?? ApiInternalStatus.FAILURE, // status code
              response.message ?? ResponseMessage.DEFAULT.tr(), // status message
            ));
          }
        } catch (error) {
          return (Left(ErrorHandler.handle(error).failure));
        }
      } else {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }
}
