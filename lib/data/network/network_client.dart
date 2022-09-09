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
    var headers = <String,dynamic>{};
    // headers.putIfAbsent("Content-Type", () => "text/plain");
    // Sec-Fetch-Site: none
    // Sec-Fetch-Mode: navigate
    // Sec-Fetch-User: ?1
    // Sec-Fetch-Dest: document
    // headers.putIfAbsent("Sec-Fetch-Site", () => "none");
    // headers.putIfAbsent("Sec-Fetch-Mode", () => "navigate");
    // headers.putIfAbsent("Sec-Fetch-User", () => "?1");
    // headers.putIfAbsent("Sec-Fetch-Dest", () => "document");
    headers.putIfAbsent("Accept", () => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9");

    dio.options = BaseOptions(headers: headers);
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
      // print("error: $error");
      // print("stack: $stackTrace");
      if(error is DioError){
        print("RESPONSE: ${error.type}");
      }
      completer.complete(Right(RemoteFailure("remote failure on $path",error)));
    });
    return completer.future;
  }
}

