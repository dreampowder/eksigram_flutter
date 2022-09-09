import 'package:eksigram/domain/model/entity/model_entry.dart';
import 'package:eksigram/domain/model/entity/model_topic.dart';
import 'package:eksigram/domain/model/entity/model_user.dart';
import 'package:eksigram/domain/model/response/res_topic.dart';

class MapperTopic{
  static ModelTopic fromResponse(ResTopic res) => ModelTopic(
      res.id,
      res.page,
      res.pageCount,
      res.entries.map((e) => ModelEntry(
          id: e.id,
          body: e.content,
          images: e.images,
          favCount: e.favCount,
          author: ModelUser(
              id: e.author.id,
              userName: e.author.userName,
              photoUrl: e.author.photoUrl
          ),
      )).toList());
}