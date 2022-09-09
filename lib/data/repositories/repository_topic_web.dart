import 'package:dartz/dartz.dart';
import 'package:eksigram/common/injection_container.dart';
import 'package:eksigram/data/network/network_client.dart';
import 'package:eksigram/domain/model/entity/model_entry.dart';
import 'package:eksigram/domain/model/entity/model_failure.dart';
import 'package:eksigram/domain/model/response/res_topic.dart';
import 'package:eksigram/domain/repository/repository_topic.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parser;
class RepositoryTopicImplWeb extends RepositoryTopic{

  late final NetworkClient _networkClient;


  RepositoryTopicImplWeb({NetworkClient? networkClient}){
    _networkClient = networkClient ?? injections();
  }

  @override
  Future<Either<ResTopic, Failure?>> getTopic(String id,int page) {
    return _networkClient.get("/$id", {"p":page}, (data){
      return _parseHtmlResponse(id,data);
    });
  }

  ResTopic _parseHtmlResponse(String id, String data){
    var document = parser.parse(data);
    var entryList = document.getElementById("entry-item-list");
    var entryElement = entryList?.getElementsByTagName("li");

    ResTopic resTopic = ResTopic(0, 0, id, []);

    var pagerElement = document.getElementsByClassName("pager");
    if (pagerElement.isNotEmpty) {
      resTopic.page = int.tryParse(pagerElement.first.attributes["data-currentpage"] ?? "") ?? 0;
      resTopic.pageCount = int.tryParse(pagerElement.first.attributes["data-pagecount"] ?? "") ?? 0;
    }

    entryElement?.forEach((entry) {

      String contentText = "";
      List<String> urls = [];
      String entryDate = "";
      String avatarUrl = "";
      String authorName = "";
      int favCount = int.tryParse(entry.attributes["data-favorite-count"] ?? "") ?? 0;



      var contentElement = entry.getElementsByClassName("content");
      if (contentElement.isNotEmpty) {
        contentText = contentElement.first.text.replaceAll("görsel", "").trim();
      }

      var urlElements = contentElement.first.getElementsByClassName("url");
      for (var urlElement in urlElements) {
        print("url: ${urlElement.attributes["href"]}");
        var attr = urlElement.attributes["href"];
        if (attr is String) {
          urls.add(attr);
        }
      }

      var authorElement = entry.getElementsByClassName("entry-author");
      if (authorElement.isNotEmpty) {
        authorName = authorElement.first.innerHtml;
      }
      var entryDates = entry.getElementsByClassName("entry-date permalink");
      if (entryDates.isNotEmpty) {
        entryDate = entryDates.first.innerHtml;
      }
      var avatarElement = entry.getElementsByClassName("avatar");
      if (avatarElement.isNotEmpty) {
        avatarUrl = avatarElement.first.attributes["src"] ?? "";
      }
      resTopic.entries.add(ResEntry(
          entry.attributes["data-id"] ?? "",
          favCount, 
          contentText, urls, 
          ResUser(entry.attributes["data-author-id"] ?? "",
              authorName,
              avatarUrl
          )
      ));
    });

    return resTopic;
  }

  @override
  Future<Either<String?, Failure?>> getImageUrl(String url) {
    return _networkClient.get(url, null, (data){
      var document = parser.parse(data);
      return document.getElementById("image")?.attributes["src"];
    },customFullUrl: url);
  }
}