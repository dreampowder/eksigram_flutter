import 'package:eksigram/domain/model/response/res_topic.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as parser;

class AppHtmlParser{
  static ResTopic parseHtmlResponse(String id, String data){
    var document = parser.parse(data);
    debugPrint("Document: ${document.body}");
    var entryList = document.getElementById("entry-item-list");
    var entryElement = entryList?.getElementsByTagName("li");

    ResTopic resTopic = ResTopic(0, 0, id, []);

    var pagerElement = document.getElementsByClassName("pager");
    if (pagerElement.isNotEmpty) {
      resTopic.page = int.tryParse(pagerElement.first.attributes["data-currentpage"] ?? "") ?? 0;
      resTopic.pageCount = int.tryParse(pagerElement.first.attributes["data-pagecount"] ?? "") ?? 0;
    }
    debugPrint("Entry elements: ${entryElement?.length}");
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

  static String? getImageString(String data){
    var document = parser.parse(data);
    return document.getElementById("image")?.attributes["src"];
  }
}