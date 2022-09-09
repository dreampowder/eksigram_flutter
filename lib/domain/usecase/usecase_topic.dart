import 'package:dartz/dartz.dart';
import 'package:eksigram/common/injection_container.dart';
import 'package:eksigram/domain/model/entity/model_failure.dart';
import 'package:eksigram/domain/model/entity/model_topic.dart';
import 'package:eksigram/domain/model/mapper/mapper_topic.dart';
import 'package:eksigram/domain/repository/repository_topic.dart';

class UseCaseTopic{

  late final RepositoryTopic _repositoryTopic;

  UseCaseTopic({RepositoryTopic? repositoryTopic}){
    _repositoryTopic = repositoryTopic ?? injections();
  }

  Future<Either<ModelTopic,Failure?>> getTopic(String id,int page) =>
      _repositoryTopic
        .getTopic(id,page)
        .then((value) => value.fold(
              (l) => Left(MapperTopic.fromResponse(l)),
              (r) => Right(r)
      ));

  Future<Either<String?,Failure?>> getRealImageUrl(String url) =>
      _repositoryTopic
          .getImageUrl(url)
          .then((value) => value.fold(
              (l) => Left(l),
              (r) => Right(r)
      ));
}