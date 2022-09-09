import 'package:eksigram/domain/model/entity/model_entry.dart';

class ModelTopic{
  String id;
  int pageCount;
  int page;
  List<ModelEntry> entries;
  ModelTopic(this.id, this.page, this.pageCount, this.entries);
}