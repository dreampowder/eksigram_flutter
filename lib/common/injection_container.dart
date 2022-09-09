import 'package:eksigram/data/network/network_client.dart';
import 'package:eksigram/data/repositories/repository_topic_web.dart';
import 'package:eksigram/domain/repository/repository_topic.dart';
import 'package:eksigram/domain/usecase/usecase_topic.dart';
import 'package:get_it/get_it.dart';

var injections = GetIt.instance;

Future<void> initializeInjections() async {

  //Common Utils
  injections.registerFactory<NetworkClient>(() => NetworkClientDio(baseUrl: "https://eksisozluk.com"));


  //Repositories
  injections.registerFactory<RepositoryTopic>(() => RepositoryTopicImplWeb());

  //Usecases
  injections.registerFactory<UseCaseTopic>(() => UseCaseTopic());

}
