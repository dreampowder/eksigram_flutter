import 'package:dartz/dartz.dart';
import 'package:eksigram/common/html_parser.dart';
import 'package:eksigram/common/injection_container.dart';
import 'package:eksigram/data/network/network_client.dart';
import 'package:eksigram/domain/model/entity/model_failure.dart';
import 'package:eksigram/domain/model/response/res_topic.dart';
import 'package:eksigram/domain/repository/repository_topic.dart';
import 'package:flutter/foundation.dart';

class RepositoryTopicImplWebGateway extends RepositoryTopic{

  late final NetworkClient _networkClient;


  RepositoryTopicImplWebGateway({NetworkClient? networkClient}){
    _networkClient = networkClient ?? injections();
  }

  @override
  Future<Either<String?, Failure?>> getImageUrl(String url) {
    return _networkClient.post("/api", null, {"url":url}, (data){
      debugPrint("GOT DATA: $data");
      return AppHtmlParser.getImageString(data);
    });
  }

  @override
  Future<Either<ResTopic, Failure?>> getTopic(String id, int page) {
    return _networkClient.post("/api", null, {"url":"https://eksisozluk.com/$id?p=$page"}, (data){
      debugPrint("GOT DATA: $data");
      return AppHtmlParser.parseHtmlResponse(id, data);
    });
  }

}