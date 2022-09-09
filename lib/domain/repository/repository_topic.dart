import 'package:dartz/dartz.dart';
import 'package:eksigram/domain/model/entity/model_entry.dart';
import 'package:eksigram/domain/model/entity/model_failure.dart';
import 'package:eksigram/domain/model/response/res_topic.dart';

abstract class RepositoryTopic{
  Future<Either<ResTopic,Failure?>> getTopic(String id,int page);
  Future<Either<String?, Failure?>> getImageUrl(String url);
}