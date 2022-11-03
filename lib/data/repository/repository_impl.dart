import 'package:clean_architect_app/data/mapper/mapper.dart';
import 'package:clean_architect_app/data/network/error_handler.dart';
import 'package:clean_architect_app/data/network/failure.dart';
import 'package:clean_architect_app/data/request/request.dart';
import 'package:clean_architect_app/domain/model.dart';
import 'package:clean_architect_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import '../data_source/remote_data_source.dart';
import '../network/network_info.dart';

class RepositoryImpl extends Repository {
  RemoteDataSource _remoteDataSource;
  NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // its safe to call API
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.SUCCESS) // success
            {
          // return data (success)
          // return right
          return Right(response.toDomain());
        } else {
          // return biz logic error
          // return left
          return Left(Failure(
              response.status ?? ApiInternalStatus.FAILURE,
              response.message ??
                  ResponseMessage.DEFAULT)); // Failure , left

        }
      } catch (error) {
       return(Left (ErrorHandler.handle(error).failure));
      }
    }else {
      // return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
