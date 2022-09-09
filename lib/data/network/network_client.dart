import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eksigram/domain/model/entity/model_failure.dart';

abstract class NetworkClient{
  Future<Either<T, Failure?>> get<T>(String path, Map<String,dynamic>? queryParameters, T Function(dynamic) dataConstructor,{String? customFullUrl});
}

class NetworkClientDio extends NetworkClient{

  String baseUrl;
  NetworkClientDio({required this.baseUrl});

  Future<Dio> getClient() async{
    Dio dio = Dio();
    return Future.value(dio);
  }


  @override
  Future<Either<T, Failure?>> get<T>(String path, Map<String, dynamic>? queryParameters, T Function(dynamic p1) dataConstructor,{String? customFullUrl}) async{
    var client = await getClient();
    var completer = Completer<Either<T, Failure?>>();
    client.get(customFullUrl ?? "$baseUrl$path",queryParameters: queryParameters)
        .then((result){
        completer.complete(Left(dataConstructor(result.data)));
    }).catchError((error, stackTrace){
      print("error: $error");
      print("stack: $stackTrace");
      completer.complete(Right(RemoteFailure("remote failure on $path",error)));
    });
    return completer.future;
  }
}

