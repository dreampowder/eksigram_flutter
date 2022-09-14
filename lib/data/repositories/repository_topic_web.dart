import 'package:dartz/dartz.dart';
import 'package:eksigram/common/html_parser.dart';
import 'package:eksigram/common/injection_container.dart';
import 'package:eksigram/data/network/network_client.dart';
import 'package:eksigram/domain/model/entity/model_entry.dart';
import 'package:eksigram/domain/model/entity/model_failure.dart';
import 'package:eksigram/domain/model/response/res_topic.dart';
import 'package:eksigram/domain/repository/repository_topic.dart';
import 'package:html/parser.dart';

class RepositoryTopicImplWeb extends RepositoryTopic{

  late final NetworkClient _networkClient;


  RepositoryTopicImplWeb({NetworkClient? networkClient}){
    _networkClient = networkClient ?? injections();
  }

  @override
  Future<Either<ResTopic, Failure?>> getTopic(String id,int page) async{
    return _networkClient.get("/$id", {"p":page}, (data){
      return AppHtmlParser.parseHtmlResponse(id,data);
    });
  }



  @override
  Future<Either<String?, Failure?>> getImageUrl(String url) {
    return _networkClient.get(url, null, (data){
      return AppHtmlParser.getImageString(data);
    },customFullUrl: url);
  }
}